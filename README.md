#skyport-api

Skyport-api is an API for the artificial intelligence game [Skyport](https://github.com/Amadiro/Skyport-logic). The game is simply put about creating an AI actor (aka bot) that traverse a hexagonal map with the objective of killing the other bots. The game is turn based and allows each bot to perform three turns. They may move, attack, mine minerals or upgrade weapons. For more details please refer to the [Skyport repository](https://github.com/Amadiro/Skyport-logic).

The repository contains an API written in JavaScript. The code is pretty basic and lack convenience features. This repository is an attempt at a better API. It contains useful features such as calculation of neighbouring tiles, caculation of the distance between two tiles, game state storage etc.

## Building the skyport-api module
The API is implemented as a javascript module intended to be run by a Node.js application. In order to use or test the skyport-api you must first clone the git repository or download it to your computer. Open the skyport-api folder in a terminal or console and run `npm install`. This will get all the development dependencies for the project including coffee-script, coffeelint, docco, grunt tasks etc. Then run `grunt` to build the project.

## Using the skyport-api module
For the time being you cannot download and manage skyport-api through npm. The project will eventually become a npm project. To use the skyport-api module follow the instructions for building the module in the section above. Once you have built the project you can copy-paste the files in the build-folder into a skyport-api folder in your Skyport AI project. To import and use the skyport-api module use the following code:
```Javascript
SkyportAPI = require(./skyportapifolder/skyportapi);

console.log("Welcome to my awesome AI!");

if (process.argv.length !== 3) {
	console.log("Usage: node skyportai.js name_of_the_bot");
	process.exit();
}

myname = process.argv[2];

api = new SkyportAPI(this.name);
```

The API use a callback structure to invoke methods in your AI code for different events fired by the server. You must implement and register functions for each kind of event:
```Javascript
this.api.on("connection", gotConnection);
this.api.on("error", gotError);
this.api.on("handshake", gotHandshake);
this.api.on("gamestart", gotGameStart);
this.api.on("gamestate", gotGameState);
this.api.on("myturn", gotMyTurn);
this.api.on("own_action", gotOwnAction);
this.api.on("action", gotAction);
```
Do note that these might change in the future.

See the RandomAI class in `src/examples/skyportai.coffee` for a [CoffeeScript based example](./tree/master/src/examples/skyportai.coffee)
, or the corresponding RandomAI function in the `build/examples/skyportai.js` for the compiled Javascript code. The skyportai.js file is not included in the GitHub repository because it is a build file. An example written in JavaScript might be included in the future.

## Contributing to the skyport-api module
There currently remain some work before the module can be packaged and uploaded as a npm module. A todo list is provided here:

1. Finish random walker example.
2. Implement more conveniance functionality?
3. Implement tests for all API methods/functions.
4. Package as a npm module and make it easily importable.

