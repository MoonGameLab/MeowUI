Clipping :

- [x] Control built in clipping
  - [x] Stencil set to -> "greater", 0

Controls :

- [x] Button : Done

- [x] ScrollBar : Done

- [X] Content

  - [x] Vbar : Done
  - [X] Hbar

TextField :


AddOns:
- [ ] Collection :
    -- Stores references to controls to enable accessing them from anywhere.
    - [ ] API:
        - newCollection({rootName: rootCtrl}, { contrlName: childCtrl, ... })
        - getCollection(rootName<string> or ctrlId<string>) returns {rootName: {contrlName: childCtrl, ...}}
          - Access collectionRoot.child <Root will be a child to -> collectionRoot.root>
        - attachControlTo(rootName<string> or ctrlId<string>, { contrlName: childCtrl } or id)
        - removeControlFrom(rootName<string> or ctrlId<string>, { contrlName: childCtrl } or id})
        - forget(rootName<string> or ctrlId<string>)
        - count(rootName<string> or ctrlId<string>)
          - Count number of child controls. `#(rootName\getChildren!)` --> size param is better




Bug_Log:

* [Button] : Buttons that use a stencil function should be drawn in a higher depth otherwise they effect the other Buttons and make them show above the Content stencil. --> Breaks the scrolling effect.
* [Button] : The border should be drawn while the stencil function is active otherwise it will show above the Content stencil. --> Breaks the scrolling effect.
* [Button] : Always set the depth before the image.
