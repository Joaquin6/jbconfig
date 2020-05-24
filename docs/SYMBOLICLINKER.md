# [SymbolicLinker](https://github.com/nickzman/symboliclinker/releases)

## How to Install

1. Open the folder titled "Library" at the root of your boot disk. Make sure there is a folder there named "Services". If the folder doesn't exist, then make one with exactly that name (without the quotes, of course). If you are not the system administrator, or you do not want the service to be available to available to all users on the system, then use the Library folder inside your home directory instead.

In other words, you want to find the /Library/Services folder. I do not recommend placing SymbolicLinker in the /System/Library/Services folder, because the System folder is intended to be reserved for Apple use only.

If you are not the administrator on your computer, or you want to restrict SymbolicLinker to running only on your account, then you can place it in your home folder's Library/Services folder instead. If you don't see the Library folder in your home folder, then choose View -> Show View Options from the Finder menu, and make sure the how Library Folder box is checked.

2. Copy the "SymbolicLinker.service" bundle that came with this distribution into the Services folder.

3. Run SymbolicLinker once by right-clicking (or Control-clicking) on the copied item's icon, and choosing 'Open'. This will start up the app once, and register it with the OS as a software service. SymbolicLinker is programmed to stay in memory for a short period of time, and then automatically quit when it is no longer needed. When it is not running, it will still show up in the services list, so this is a purely memory-saving move.

4. You should also make sure that the service is enabled (sometimes it is by default, sometimes it isn't). To do that, open System Preferences, open the Keyboard preference pane, open the Keyboard Shortcuts tab, click on Services, and scroll through the list until you see the "Make Symbolic Link" service. If the service is checked, then it will appear in the Finder. If it isn't, then it won't.

## How to Remove

1. Find the "SymbolicLinker.service" folder you installed and move it to the trash.

2. Empty the trash.

3. SymbolicLinker will eventually disappear from the Finder's contextual menu items, either after you've logged out and back in again, or rebooted, or run another application that updated your services.

Usage

1. Highlight the icon(s) you want to make into symbolic links using your mouse or keyboard.

2. Bring up the contextual menu. If you have never done this before, here's how you do it:

    2a. If your mouse/trackball has one mouse button, or if you are using an iBook or PowerBook, then click on the item you want to make into a symbolic link while holding down the Control key on your keyboard. (Click on the item, not the menu bar.)

    2b. If your mouse/trackball has two or more buttons, then you can right-click on the item you want to make into a symbolic link.

    2c. If you are using a Mighty Mouse or Magic Mouse, or an Apple laptop made during or after 2006 (MacBook, MacBook Pro, etc.), then you can alternate-click on the item. You can turn on alternate-clicking in System Preferences' mouse and trackpad preference panes; it usually isn't on by default.

3. If the service is installed and checked in the Keyboard preference pane's service list, then it will show up in the Finder's regular contextual menu, like this:
