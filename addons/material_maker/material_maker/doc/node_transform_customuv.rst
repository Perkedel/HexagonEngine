CustomUV node
~~~~~~~~~~~~~

The **CustomUV** node deforms an input image according to a custom UV map given as input.

.. image:: images/node_transform_customuv.png
	:align: center

Inputs
++++++

The **CustomUV** node accepts two inputs:

* The *Source* inputs is the image to be deformed.

* The *UV* input is a color image whose red and green channels are used as
  U and V (X and Y in texture space) coordinates, and the blue channel holds
  a value to be used for pseudo-random scale and rotate transforms.

Outputs
+++++++

The **CustomUV** node outputs the deformed image.

Parameters
++++++++++

The **CustomUV** node accepts a *scale* and a *rotate* parameters that define
the strength of the random scale and rotate transforms applied locallly to
the result.
