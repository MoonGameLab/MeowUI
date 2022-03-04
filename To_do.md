Clipping :

- [x] Control built in clipping 
  - [x] Stencil set to -> "greater", 0

Controls :

- [x] Button : Done

- [x] ScrollBar : Done

- [ ] Content

  - [x] Vbar : Done
  - [ ] Hbar 
  
  

Bug_Log:

* [Button] : Buttons that use a stencil function should be drawn in a higher depth otherwise they effect the other Buttons and make them show above the Content stencil. --> Breaks the scrolling effect.
* [Button] : The border should be drawn while the stencil function is active otherwise it will show above the Content stencil. --> Breaks the scrolling effect.
* [Button] : Always set the depth before the image. 
