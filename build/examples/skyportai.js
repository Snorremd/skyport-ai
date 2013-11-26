(function() {
  var RandomAI, SkyportAPI, ai, myname,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  SkyportAPI = require("../skyportapi");

  RandomAI = (function() {
    function RandomAI(name) {
      this.name = name;
      this.gotMyTurn = __bind(this.gotMyTurn, this);
      this.gotGameState = __bind(this.gotGameState, this);
      this.gotGameStart = __bind(this.gotGameStart, this);
      this.gotHandshake = __bind(this.gotHandshake, this);
      this.gotError = __bind(this.gotError, this);
      this.gotConnection = __bind(this.gotConnection, this);
      this.api = new SkyportAPI(this.name);
      this.api.on("connection", this.gotConnection);
      this.api.on("error", this.gotError);
      this.api.on("handshake", this.gotHandshake);
      this.api.on("gamestart", this.gotGameStart);
      this.api.on("gamestate", this.gotGameState);
      this.api.on("myturn", this.gotMyTurn);
      this.api.on("own_action", this.gotOwnAction);
      this.api.on("action", this.gotAction);
      this.api.connect();
      this.myActions = ["move", "laser", "mortar"];
    }

    RandomAI.prototype.gotConnection = function() {
      console.log("Got connection");
      return this.api.sendHandshake(this.name);
    };

    RandomAI.prototype.gotError = function(errorObject) {
      console.log("Server sent error");
      return console.log(errorObject);
    };

    RandomAI.prototype.gotHandshake = function() {
      return console.log("Got handshake from server");
    };

    RandomAI.prototype.gotGameStart = function(gamestate) {
      console.log(JSON.stringify(gamestate));
      console.log("Got gamestart, send loadout");
      return this.api.sendLoadout("laser", "mortar");
    };

    RandomAI.prototype.gotGameState = function(gamestate) {
      return console.log("Got game state for enemy turn");
    };

    RandomAI.prototype.gotMyTurn = function(gamestate) {
      var choice;
      choice = "move";
      switch (choice) {
        case "move":
          return this.randomMove(gamestate);
        default:
          return console.log("Nothing");
      }
    };

    RandomAI.prototype.gotOwnAction = function(type, actionDetails) {
      return console.log("Got own action");
    };

    RandomAI.prototype.gotAction = function(type, actionDetails, aiName) {
      return console.log("Got AI action");
    };

    RandomAI.prototype.randomMove = function(gamestate) {
      var direction, myHex, myPos, neighbours, randNeighbour,
        _this = this;
      myPos = gamestate.players[0].position;
      myHex = gamestate.map.mapData[myPos.j][myPos.k];
      neighbours = gamestate.map.neighbours(myHex);
      neighbours = neighbours.filter(function(hexagon) {
        return gamestate.map.walkable(hexagon.j, hexagon.k);
      });
      randNeighbour = neighbours[Math.floor(Math.random() * neighbours.length)];
      direction = myHex.direction(randNeighbour);
      console.log("My position is " + JSON.stringify(myHex));
      console.log("My neighbours are " + JSON.stringify(neighbours));
      console.log("Move " + direction);
      return this.api.move(direction);
    };

    return RandomAI;

  })();

  console.log("Welcome to Random Walker AI");

  if (process.argv.length !== 3) {
    console.log("Usage: node skyportai.js name_of_the_bot");
    process.exit();
  }

  myname = process.argv[2];

  ai = new RandomAI(myname);

}).call(this);
