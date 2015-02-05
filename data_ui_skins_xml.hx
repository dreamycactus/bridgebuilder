(function(){
ru.stablex.ui.UIBuilder.skins.set("matBut", function():ru.stablex.ui.skins.Skin{
var skin = new ru.stablex.ui.skins.Paint();
skin.color = 0x6c71c4;
skin.borderColor = 0x5e62a9;
skin.border = 1;
return skin;
});
ru.stablex.ui.UIBuilder.skins.set("EditorRow", function():ru.stablex.ui.skins.Skin{
var skin = new ru.stablex.ui.skins.Paint();
skin.color = 0x558888;
skin.borderColor = 0x000000;
skin.border = 1;
return skin;
});
ru.stablex.ui.UIBuilder.skins.set("EditorPanel", function():ru.stablex.ui.skins.Skin{
var skin = new ru.stablex.ui.skins.Paint();
skin.color = 0x888888;
skin.borderColor = 0x222222;
skin.border = 2;
return skin;
});})()