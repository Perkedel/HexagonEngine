# Stopwatch Plugin for Godot Engine 3.x
This is a plugin for [Godot Engine](https://godotengine.org/) that adds [stopwatch](https://en.wikipedia.org/wiki/Stopwatch) functionality via a custom node. It extends from [Node](https://docs.godotengine.org/en/3.0/classes/class_node.html).

## Installation
Create an `addons` folder in your project folder if it doesn't exist already. Clone or download and extract the repo into the `addons` folder. The directory tree should look like this:

    Your-Project
        addons
            godot-stopwatch
                ...stopwatch plugin files
            ...other plugins
        ...the rest of your files

From there, you can enable the plugin by clicking on `Project` in the menu and opening `Project Settings`. Select the `Plugins` tab and enable the `Stopwatch` plugin.

## Usage
Add a `Stopwatch` node to your scene tree and call any of the available functions and signals. Some functions accept arguments, and all have default initializations so they can be called without arguments.

### Editor Variables:
| Variable   | Type      | Description                                                                                                                                                                   |
|------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `started`  | `boolean` | Determines whether the stopwatch has been started or not.                                                                                                                     |
| `paused`   | `boolean` | Determines whether the stopwatch is currently paused or not.                                                                                                                  |
| `max_time` | `float`   |  The max time the stopwatch can support in `[seconds].[milliseconds]` format. The default value is `86399.999` which will result in a maximum elapsed time of `23:59:59:999`. |

### Functions:
| Function                       | Description                                                                                         |
|--------------------------------|-----------------------------------------------------------------------------------------------------|
| `start()`                      | Resets and starts the stopwatch.                                                                    |
| `pause()`                      | Pauses the stopwatch.                                                                               |
| `resume()`                     | Resumes the stopwatch from a paused state.                                                          |
| `stop()`                       | Stops the stopwatch.                                                                                |
| `reset()`                      | Resets the stopwatch back to 0.                                                                     |
| `get_elapsed_time()`           | Gets the current elapsed time as a decimal. The format is `[total_seconds].[current_milliseconds]`. |
| `get_formatted_elapsed_time()` | Gets the current elapsed time as a formatted string. The default format is `HH:mm:ss:SSS`.          |

### Signals
| Signal      | Description                                             |
|-------------|---------------------------------------------------------|
| `started()` | Emitted when the stopwatch has been started.            |
| `paused()`  |  Emitted when the stopwatch has been paused.            |
| `resumed()` | Emitted when the stopwatch has been resumed.            |
| `stopped()` | Emitted when the stopwatch has been stopped.            |
| `reset()`   | Emitted when the stopwatch has been reset.              |
| `ticked()`  | Emitted when the stopwatch's elapsed value has changed. |

## Documentation
A wiki will eventually be made. Until then, the code is well documented, so don't be afraid to read it!

## License
This project is licensed under the MIT license.

## Version History

### Version 1.0.0
    - Initial release.