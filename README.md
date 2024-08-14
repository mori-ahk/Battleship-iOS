
<div style="text-align: center">
  <img src="https://github.com/mori-ahk/Battleship-iOS/blob/main/ShipGame/Battleship/Assets.xcassets/AppIcon.appiconset/Battleship%20Logo%20v1%20iOS%402x%20alpha.png" alt="drawing" width="200" height="200"/>
</div>



# Battleship


**Battleship** is an open-source iOS game where you can play the classic game of Battleship. This app allows players to connect with a web socket server for real-time gameplay. 

## Features

- Classic Battleship gameplay
- Real-time multiplayer using WebSocket
- Customizable game settings

## Installation

To install and run the Battleship app, follow these steps:

### Prerequisites

- Xcode 15.4 or later
- iOS 17.2+ (Simulator or physical device)
- WebSocket server for real-time communication: (check [here](https://github.com/saeidalz13/battleship-backend.git))

### Step 1: Clone the Repository

```bash
git clone https://github.com/mori-ahk/Battleship-iOS.git 
cd Battleship-iOS/ShipGame
```

### Step 2: Set the Bundle Identifier

1.    Open the Battleship.xcodeproj in Xcode.
2.    Go to the General tab.
3.    In the Identity section, set the Bundle Identifier to a unique string (e.g., com.yourname.battleship).

### Step 3: Set the WebSocket Server URL

1.    Set the value to the URL of your WebSocket server [here](https://github.com/mori-ahk/Battleship-iOS/blob/6e4c7658229d43ca9ae1ad2b4741c4543ab4012a/ShipGame/Battleship/WebSocketLayer/Endpoint.swift#L18)

### Step 4: Build and Run

1.    Select your target device (Simulator or physical device).
2.    Press Cmd + R to build and run the app.

### Usage

1.    Launch the app on your iOS device.
2.    Start a new game or join an existing one.
