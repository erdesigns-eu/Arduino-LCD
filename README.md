# Arduino-LCD Components for Delphi
Components used for my Custom LCD Character creator, and projects that are not released yet.

The character container component (TLCDCharacterContainer) is a simple component for drawing custom characters. You can use the mouse to select the pixels you want to light up, and this makes it easier to design or edit characters.

![Custom LCD Character Creator](https://erdesigns.eu/images/char_creator_1.png)
![Custom LCD Character Creator](https://erdesigns.eu/images/char_creator_2.png)

The LCD Display component (TLCDDisplay) is a simple component that preview text or characters. You can change the Rows and Columns, the color, size of the Pixels and more. I use this component in my new application for creating custom characters, and design animations for the LCD display running on a Arduino.
The component can be used as a preview - but can also work as a component for displaying information. I added Upper/Lower alphabet, decimals and a very few special characters to the code, you can expand these in the untLCDCharacters.pas unit. 
The characters for both components are a multidimensional array of boolean (pixel is ON or OFF).

![Custom LCD Character Creator](https://erdesigns.eu/images/char_creator_4.png)

You can use these components freely, and to your liking - although it would be nice if you give me credits for the work. If you update the code, or add new functionality - please send me a copy so i can update the Git. I will add some of the projects using these components later on.

Demo code can be found here: https://erdesigns.eu/app/delphi/view/5
