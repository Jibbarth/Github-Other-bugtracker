package com.barth.gob.extend;

import chrome.Events;
import chrome.Tabs;
import chrome.Runtime;

@:require(chrome)
@:native("chrome.runtime")
extern class RuntimeResponse extends Runtime{
    static var onMessage(default,never) : Event<?Dynamic->MessageSender->(?Dynamic->Void)->Void>;
}
