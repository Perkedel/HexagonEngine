extends Node

class WebClient:
	var _debug := false
	var _headers = PackedStringArray([])
	var _client = null
	var object = null
	var callback = null
	var user_data = null
	var _method = HTTPClient.METHOD_GET
	var _path = null
	var _body = null
	var _response_headers = null
	var _response_body = null
	var _response_code = null
	var _native_network: Object = null
	
	func _init():
		_debug = OS.is_debug_build()
		if Engine.has_singleton('Network'):
			_native_network = Engine.get_singleton('Network')
		self._client = HTTPClient.new()
		self._client.blocking_mode_enabled = false

	func poll():
		var status = _client.get_status()
		var err = OK
		if status == HTTPClient.STATUS_RESOLVING:
			err = _client.poll()
		elif status == HTTPClient.STATUS_CONNECTING:
			err = _client.poll()
		elif status == HTTPClient.STATUS_REQUESTING:
			err = _client.poll()
		elif status == HTTPClient.STATUS_CONNECTED:
			if _response_code == null:
				err = _client.request(_method, _path, _headers, _body)
			else:
				# already have a response
				_finish_request(null, _response_code, _response_headers, _response_body)
		elif status == HTTPClient.STATUS_BODY:
			if _client.has_response():
				if _response_headers == null:
					_response_headers = _client.get_response_headers_as_dictionary()
				if _response_code == null:
					_response_code = _client.get_response_code()
					if _response_code >= 300 and _response_code <= 308:
						# redirect
						if 'Location' in _response_headers:
							var new_url = _response_headers['Location']
							if new_url != null and new_url.length() > 0:
								_client.close()
								_perform_request(_method, new_url, _body)
						pass
					elif _response_code != 200:
						_client.close()
						_finish_request(null, _response_code, _response_headers, _response_body)
						return
				err = _client.poll()
				var chunk = _client.read_response_body_chunk()
				if chunk.size() > 0:
					_response_body += chunk
		if err != OK:
			push_error('Networking error: %s'%var_to_str(err))

	func _perform_request(method, url, data=''):
		if _debug:
			print('Start web request: %s\nwith data: %s'%[url,data])
		_response_body = PackedByteArray()
		_response_headers = null
		_response_code = null
		_method = method
		_body = data
		var protocol = null
		var host = null
		var port = -1
		var ssl = false
		_path = null
		var s1 = url.split('://', false)
		if s1.size() > 1:
			protocol = s1[0]
			url = s1[1]
		if url.find('/') > 0:
			var pos = url.find('/')
			host = url.left(pos)
			_path = url.right(pos)
		if host.find(':') > 0:
			var pos = host.find(':')
			port = host.right(pos+1)
			host = host.left(pos)
		if protocol == 'https':
			ssl = true
		var err = _client.connect_to_host(host, int(port), ssl)
		if err != OK:
			push_error('Networking error: %s'%var_to_str(err))

	func _finish_request(result, response_code, headers, body):
		if _debug:
			print('Finish web request with result: %d'%response_code)
		if self.object != null and self.callback != null:
			self.object.callv(self.callback, [response_code, body.get_string_from_utf8(), self])
		_client.close()
		self.callback = null
		self.object = null
		self._headers = PackedStringArray([])
		self.user_data = null
	
	func _native_finish_request(response_code, body):
		if _debug:
			print('Finish native web request with result: %d'%response_code)
		if self.object != null and self.callback != null:
			self.object.callv(self.callback, [response_code, body, self])
		self.callback = null
		self.object = null
		self._headers = PackedStringArray([])
		self.user_data = null

	func set_headers(headers):
		self._headers.append_array(headers)

	func method_get(url, object, callback, data=null):
		if busy():
			push_error('Web Client is busy!')
			return
		self.object = object
		self.callback = callback
		if data != null:
			data = self._client.query_string_from_dict(data)
			url = url + '?' + data
		if _native_network != null:
			_native_network.get_request(url, self.get_instance_id(), '_native_finish_request')
		else:
			self._perform_request(HTTPClient.METHOD_GET, url)

	func method_post(url, object, callback, data={}):
		if busy():
			push_error('Web Client is busy!')
			return
		self.object = object
		self.callback = callback
		self._headers.append_array(['Content-Type: application/x-www-form-urlencoded'])
		data = self._client.query_string_from_dict(data)
		self._perform_request(HTTPClient.METHOD_POST, url, data)

	func post_json(path, object, callback, data={}, headers=[]):
		if busy():
			push_error('Web Client is busy!')
			return
		self.object = object
		self.callback = callback
		data = JSON.stringify(data)
		self._headers.append_array(['Content-Type: application/json'])
		self._headers.append_array(["Content-Length: " + str(data.length())])
		self._headers.append_array(headers)
		self._perform_request(HTTPClient.METHOD_POST, path, data)

	func busy():
		return _client.get_status() != HTTPClient.STATUS_DISCONNECTED
