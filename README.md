# CS326 Final Project - Ticket To Ride Board Builder

Group Members: Kaizen Conroy, Dominic Chui

Vision Statement: Kaizen will update this

Feature List:
  * Make a Ticket To Ride graph based off of an uploaded image
  * User can zoom/pan around the screen
  * Create a basic TTR game engine for 1 player
  * Bonus: Autogenerate destination tickets based off of board

UI Sketches: photos coming later

Key Use Cases:
  Case 1: User optionally uploads an image and adds nodes at specific locations. User can create edges between nodes and specify the number of trains fit on each edge. User can save completed board (maybe). User can interact with board by adding trains to connect edges and complete routes. 
  Case 2: User starts with a saved board. Can play 1-person version of TTR by playing trains and completing destination tickets. 

Domain Analysis:
  Ticket To Ride: link to wiki article

Architecture:
  Model: Will be based off of our graphADT. 
  View: User can click a location to place a node, or drag between nodes to create an edge, or click a button to delete items. Also will have save button and load button. 
  Controller: A user click will add a node to the graph, a user drag will add an edge to the graph, using the delete button will delete node/edge from the graph. 
  
  
  We can use a Dictionary to represent cards We will have a number to represent amount of trains and a list to represent 
  
