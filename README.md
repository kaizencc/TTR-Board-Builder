# CS326 Final Project - Ticket To Ride Board Builder + Player

### Group Members: Kaizen Conroy, Dominic Chui

### Overview:

The TTR Board Builder app is a multi view app that allows users to build custom TTR boards and interact with their board through basic gameplay. It is broken down into two views: the builder and the player. 

To build a board, the user has the option to start from scratch, upload a map background for guidance, or load in a pre-built graph. They can add nodes, edges with multiple colors, delete nodes or edges, move nodes around, or just clear all. The underlying graph model stores the information and can translate it into a .json file. 

To interact with the user-built board, the user can navigate to the play view where they can generate a random destination ticket between two nodes in their graph. The view prompts the user with the minimum-cost path between the two nodes calculated through dijkstra's algorithm. The user can draw their path between the two nodes selecting one node at a time, and can also undo their moves. When the destination ticket is completed, the selected path lights up. 

### UI Snapshots: 
  ![Build Screen](Images/Builder.png)
  ![Play screen](Images/Player.png)
  
### Feature List (~~strikethrough~~ == completed):

1. ~~Upload images as background (load images out of photo library)~~ 
2. ~~UI to add nodes and edges~~
   - ~~click to add node, click and reclick for edges~~
   - ~~calculate edge weight based on distance~~
   - ~~let user specify color somehow?~~
   - ~~Use GraphADT to store nodes, edges with coordinates~~
3. ~~Zoom and pan~~
4. ~~Add edge colors to model~~ 
   - ~~Add new struct for edge label~~
   - ~~Allow view to show multiple routes on an edge~~
5. ~~Allow user to type name for nodes~~
6. ~~Multiple Views~~
7. ~~Save/load~~
8. ~~Puzzle view~~
   - ~~Pass model along to puzzle view~~
   - ~~Connect graphview gestures~~
   - ~~Allow user to complete a route~~
   - ~~Add destination ticket generator through dijsktras algorithm~~
9. ~~Load premade files into builder~~
   
### Bug To Be Quashed
- Background isn't preserved between pages

### Nice Things to Have
- ~~Delete edges in view~~
- Change edge color in view
- ~~Duplicate edges have scaled distances (not hardcoded)~~
- ~~Highlight the selected color when adding edges~~
- ~~Alert prompt for clearing all~~
- ~~Dynamic font size and edge width~~
- ~~Save current graph as image or json file~~

## Our initial goals are stated here: 

### Vision Statement: 
We plan on building a Ticket To Ride Board Builder (and potentially game engine) by leveraging the software skills we have learned in CS326. Our primary goal is to allow the user to create and save custom Ticket To Ride graphs on our iOS app. A secondary goal is to allow the user to partake in basic TTR gameplay using their custom graph. The primary features include functionality to include photo uploads and allow for users to create graphs by being responsive to touches and dragging. The intended users are TTR afficionados like ourselves who would enjoy playing TTR on custom graphs. We hope for a basic outcome of being able to create new graphs based off of the proportions of an uploaded map.

### Feature List:
  * Allows user to upload an image (map)
  * Access to map of Williams College, map of US, map of NYC/Boston
  * User can create custom TTR graph by adding/deleting nodes and edges 
  * User can zoom/pan around the screen
  * Bonus: Create a basic TTR game engine for 1 player
  * Bonus: Autogenerate destination tickets based off of board

### Key Use Cases:

  Case 1: User optionally uploads an image and adds nodes at specific locations. User can create edges between nodes and specify the number of trains fit on each edge. User can save completed board (maybe). User can interact with board by adding trains to connect edges and complete routes. 
  
  Case 2: User starts with a saved board. Can play 1-person version of TTR by playing trains and completing destination tickets. 

### Domain Analysis:

  Ticket To Ride: https://en.wikipedia.org/wiki/Ticket_to_Ride_(board_game)
  
  TTR Game Engine: keeps track of the deck of railway cards, destination tickets, amount of trains left per player.

### Architecture:

  Model: Will be based off of our graphADT.
  
  View: User starts off with welcome page giving options to play, build, or upload. Upload options allows for image to be uploaded. Build option allows user to build a new graph either on a blank canvas or over the uploaded image. Here, the user has options to add a node, add an edge, or delete items. They can also save button and go back to welcome page. The play option gives the user a choice of graph to pick, and then allows for gameplay. This is part of our bonus features, not our initial idea. 
  
  Controller: A user will use buttons and click to add a node to the graph, a user drag will add an edge to the graph, using the delete button will delete node/edge from the graph. 
  
  
  



