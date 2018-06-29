const hOG = require('react-hyperscript');
import {View, Text, Button} from 'react-native';

function h(componentOrTag, properties, children){
    let realComponent = componentOrTag;
    if(typeof componentOrTag === 'string'){
        const tag = componentOrTag.split(".")[0];
        switch(tag.toLowerCase()){
            case "div":
                realComponent = View
            break;
            case "span":
                realComponent = Text
            break;
            case "p":
                realComponent = Text
            break;
            case "h1":
                realComponent = Text
            break;
            case "h2":
                realComponent = Text
            break;
            case "button":
                realComponent = Button
            break;
        }
    }
    
    return hOG(realcomponent, properties, children);
}

module.export = h