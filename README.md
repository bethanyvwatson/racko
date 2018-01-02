#Ruby Racko
Race to sort your rack of cards by number.


## Understanding the Game Display
The Game Display can be broken down into logical three sub-sections: 
1. The Title Screen
2. The Game Table
3. The I/O Section

The contents of each section differs depending on the game state, but players can rely on this general layout to help orient themselves during gameplay.

Let's take a closer look at the purpose and contents of each section of the Game Display.

### The Title Screen
Whenever you play *Ruby Racko*, you will see the game's title at the top of your terminal.
```
 	  ___      _           ___         _        
 	 | _ \_  _| |__ _  _  | _ \__ _ __| |_____  
 	 |   / || | '_ \ || | |   / _` / _| / / _ \ 
 	 |_|_\\_,_|_.__/\_, | |_|_\__,_\__|_\_\___/ 
 	                |__/                        
 
```
This helps provide some continuity to the user interface throughout the game. 

### The Game Table
The Game Table is the most important section of the Game Display - and the most variable.

Before the game begins, the Game Table appears empty, like so:
```
 	--------------------------------------------------
 
 	--------------------------------------------------
```

Think of the space between these vertical lines as the "shared" table space between all players. 

During gameplay, players will see the Draw Pile and Discard Pile displayed between these vertical lines:

```
	--------------------------------------------------
	Draw Pile: ??          Discard Pile: 03
	--------------------------------------------------
```

During a player's turn, the Game Table expands to include information about the current player's rack of cards. For example:

```
	--------------------------------------------------
	Draw Pile: ??          Discard Pile: 03
	--------------------------------------------------

	Beth's Turn
	57 / 43 / 22 / 42 / 46 / 30 / 26 / 12 / 56 / 21
	 a    b    c    d    e    f    g    h    i    j
 ```
 Here we see Beth's private rack information in addition to the shared table space. Each number represents a card in Beth's rack. 
 
 The letters below each number describe that card's location in the rack. In this example, the number `46` is at location `e`. Players use this location information to indicate which card they wish to replace during their turn.
 
 ### The I/O Section
 Players can always find the I/O Section at the bottom of the Game Display. The I/O section consists of a prompt or question, and the options users can select in response. Each possible response to a prompt corresponds to one or more valid inputs, which are displayed in parenthesis next to each possible response. 
 ```
 Before we start, do you want to read the rules for Ruby Racko?
	Read Rules (1/y/yes)
	Skip Rules (0/n/no)
	Exit Game (qq/quit)
``` 
Players must indicate their response by typing one of the corresponding valid inputs into the terminal and pressing `enter` or `return`.

Given the above prompt, for example, a player could skip the rules by typing `0` and `enter`.

### Putting it All Together
Here is an example of what the entire Game Display looks like in the middle of a player's turn:
```
 	  ___      _           ___         _        
 	 | _ \_  _| |__ _  _  | _ \__ _ __| |_____  
 	 |   / || | '_ \ || | |   / _` / _| / / _ \ 
 	 |_|_\\_,_|_.__/\_, | |_|_\__,_\__|_\_\___/ 
 	                |__/                        
 
	--------------------------------------------------
	Draw Pile: ??          Discard Pile: 12
	--------------------------------------------------

	Beth's Turn
	32 / 49 / 21 / 05 / 06 / 28 / 08 / 22 / 10 / 01
	 a    b    c    d    e    f    g    h    i    j
Do you want to draw a new card, or use the top discarded card?
	Draw New Card (1/y/yes)
	Take Last Discarded Card (0/n/no)
	Exit Game (qq/quit)
```
