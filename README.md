#skyport-api

Skyport-api is an API for the artificial intelligence game
[Skyport](https://github.com/Amadiro/Skyport-logic). The game is simply put
about creating an AI actor (aka bot) that traverse a hexagonal map with the
objective of killing the other bots. The game is turn based and allows each
bot to perform three turns. They may move, attack, mine minerals or upgrade
weapons. For more details please refer to the
[Skyport repository](https://github.com/Amadiro/Skyport-logic).

The repository contains an API written in JavaScript. The code is pretty basic
and lack convenience features. This repository is an attempt at a better API. It
contains useful features such as calculation of neighbouring tiles, calculation
of the distance between two tiles, game state storage etc.

## Building the skyport-api module
The API is implemented as a javascript module intended to be run by a Node.js
application. In order to use or test the skyport-api you must first clone the
git repository or download it to your computer. Open the skyport-api folder in
a terminal or console and run `npm install`. This will get all the development
dependencies for the project including coffeescript, coffeelint, docco, grunt
tasks etc. Then run `grunt` to build the project.

## Using the skyport-api module
For the time being you cannot download and manage skyport-api through npm.
The project will eventually become a npm project. To use the skyport-api module
follow the instructions for building the module in the section above. Once you
have built the project you can copy-paste the files in the build-folder into a
skyport-api folder in your Skyport AI project. To import and use the skyport-api
module use the following code:

```Javascript
SkyportAPI = require(./skyportapifolder/skyportapi);

console.log("Welcome to my awesome AI!");

if (process.argv.length !== 3) {
	console.log("Usage: node skyportai.js name_of_the_bot");
	process.exit();
}

myname = process.argv[2];

api = new SkyportAPI(myname);
```

The API use a callback structure to invoke methods in your AI code for different
events fired by the server. You must implement and register functions for each
kind of event:

```Javascript
api.on("connection", gotConnection);
api.on("error", gotError);
api.on("handshake", gotHandshake);
api.on("gamestart", gotGameStart);
api.on("gamestate", gotGameState);
api.on("myturn", gotMyTurn);
api.on("own_action", gotOwnAction);
api.on("action", gotAction);
```

Do note that these might change in the future.

See the RandomAI class in `src/examples/skyportai.coffee` for a
[CoffeeScript based example](./tree/master/src/examples/skyportai.coffee)
, or the corresponding RandomAI function in the `build/examples/skyportai.js`
for the compiled Javascript code. The skyportai.js file is not included in the
GitHub repository because it is a build file. An example written in JavaScript
might be included in the future.

## Contributing to the skyport-api module
There currently remain some work before the module can be packaged and uploaded
as an npm module. A todo list is provided here:

1. Finish random walker example.
2. Implement more convenience functionality?
3. Implement tests for all API methods/functions.
4. Package as a npm module and make it easily importable.

### Documentation
Write documentation in present tense: "Locate the player on the map". Write
from the method's perspective. Class documentation should describe the purpose
of the class. Use concise sentences. Long sentences only serve to confuse.
Use in-line comments sparingly, in cases where the code is unclear. Clearer
code is (almost) always better than in-line documentation.

### Code style

In lieu of a formal style guide the build script runs
[CoffeeLint](http://www.coffeelint.org/) with the default parameters.
You can also use a CoffeeScript linter in your favourite editor or IDE.
Essentially the default settings help you write more idiomatic CoffeeScript
code.

Style choices not caught by the linter that you are encouraged to follow:
#### Vertical spacing
There should be one line spacing between the following items:
- Class properties
- Class methods
- Instance methods

There should be two line spacing between:
- End of class definitions and module code.

Example:
```Coffeescript
# Module doc


# Import doc
Connection = require("./skyportconnection")
GameState = require "./gamestate"


# Class doc
class SkyportAPI

  # Constructor doc
  constructor: (@name) ->
    @dispatchTable = {}
    @gamestate = null
    @connection = new Connection "localhost", 54321, this

  # Method doc
  connect: () ->
    @connection.connect()

  # Method doc
  on: (signal, handler) ->
    @dispatchTable[signal] = handler


# Other module code
somevalue = someMethod someParameter
```

### Testing
Currently there are no tests to run against the API. Please test your code
profusely before sending a pull request. Describe the changes done and how to
test them in the pull request message.

### Bug reports
If you discover bugs or other issues with the API, please submit an issue
[here](https://github.com/Snorremd/skyport-api/issues).

## License
The MIT License (MIT)

Copyright (c) 2013 Snorre Magnus Davøen

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
