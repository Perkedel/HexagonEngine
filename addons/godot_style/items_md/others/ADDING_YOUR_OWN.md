# Adding your own


This is an how you can add your own `SectionResources` and `ItemResources` to the addon.
Have fun tinkering!


## Adding a new `Section` 

1. Right-click on a directory -> Choose **Create New** -> Choose **Resource**  
   
2. Search for `SectionResource`, press **Create** and give a file name  
 
3. Double-click on the newly created `SectionResource` -> Its properties appear in the **Inspector** tab.  
   
4. Change **Name**  
 
5. Click on the Array **Items** -> Add your `ItemResources` -> Configure their properties  
   
6. Finally, add the `SectionResource` to the addon's main scene
	- Open `godot_style/main.tscn`  
  
	- In the **Scene** tab, double-click **Main** - the top **Control** node  
  
	- In the **Inspector** tab, add your `SectionResource` to the Array **Sections**

		![main](addons/godot_style/pictures/main.PNG)

>**Note:** To trigger update, disable and re-enable the addon (or reload the current project or the game engine).



## Adding a new `Item`

1. Right-click on a directory -> Choose **Create New** -> Choose **Resource**  
   
2. Search for `SectionResource`, press **Create** and give a file name  
 
3. Double-click on the newly created `ItemResource` -> Its properties appear in the **Inspector** tab.  
   
4. Change **Name** and **Content Title**  

5. Locate your Markdown file `file_name.md` in **Content Path**  

6. Finally, add the `ItemResource` to its corresponding `SectionResource`
	![add_item](addons/godot_style/pictures/add_item.PNG)

>**Note:** To trigger update, use the shortcut CTRL+R on the Style tab **OR** disable and re-enable the addon (or reload the current project or the game engine).


## Notes

### To trigger any update, disable and re-enable the addon (or reload the current project or the game engine).

![enabling-addon](addons/godot_style/pictures/enable_addon.PNG)


### Saving custom resources

- Both `ItemResource` and `SectionResource` can be saved into disk or created as internal resources.  

- For example, in this addon, `SectionResources` are saved while `ItemResources` are internal resources.
