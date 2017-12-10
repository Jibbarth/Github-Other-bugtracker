package com.barth.gob;

import js.html.TextAreaElement;
import js.html.HTMLCollection;
import js.html.InputElement;
import js.html.LabelElement;
import js.html.Element;
import js.Browser;
import js.jquery.JQuery;
import com.barth.gob.tools.Uuid;
import haxe.Json;

/**
 *  Utility for replace commit in a comment form
 */
class Comment
{
    private var regCommitNumber:EReg = ~/(^|[^\[])#([0-9\d-]+)/g;
    private var _bugTrackerIssueUrl:String;
    private var _defaultRewriteEnabled:Bool = false;

    public function new()
    {
        init();
        trace('init Comment');
    }

    public function init():Void
    {
        var textAreaCollection:HTMLCollection = cast Browser.document.getElementsByTagName('textarea');
        for (i in 0 ...textAreaCollection.length) {
            var txtArea:TextAreaElement = cast textAreaCollection[i];
            setRewriteFeature(txtArea, _defaultRewriteEnabled);
            addRewriteLink(txtArea);
        }

        createCommentFormHandler();
    }

    public function replaceTextareaContentHandler(elem:TextAreaElement):Void
    {
        if (Json.parse(elem.getAttribute(ElementId.TXTAREA_DATA_REWRITE))) {
            elem.value = getContentWithCommitLink(elem.value);
        }
    }

    public function setBugTrackerUrl(url:String):Void
    {
        _bugTrackerIssueUrl = url;
    }

    public function getContentWithCommitLink(content):String
    {
        return regCommitNumber.replace(content, '$1[#$2]('+_bugTrackerIssueUrl+'$2)');
    }

    private function createCommentFormHandler():Void
    {
        Browser.document.addEventListener('click', function(event) {
            var el:Element = cast event.target || event.srcElement;
            if (el.className.indexOf(ElementId.COMMENT_FORM) >= 0) {
                el.addEventListener('blur', leaveCommentFormDescHandler);
            }
        });
    }

    private function setRewriteFeature(elem:TextAreaElement, enable:Bool):Void
    {
        elem.setAttribute(ElementId.TXTAREA_DATA_REWRITE, cast enable);
    }

    private function leaveCommentFormDescHandler(event:Dynamic):Void
    {
        var elem:TextAreaElement = cast (event.target || event.srcElement);
        replaceTextareaContentHandler(elem);
    }

    private function addRewriteLink(elem:TextAreaElement)
    {
        if (isCommentTextArea(elem)) {
            var formHead = new JQuery(elem).parents('form').find('.' + ElementId.COMMENT_FORM_HEAD + ' .toolbar-commenting');
            var uuid:String= Uuid.generate();

            elem.classList.add('gob_' + uuid);

            var groupElement:Element = cast Browser.document.createElement('div');
            groupElement.classList.add('toolbar-group');
            groupElement.classList.add('gob-rewrite');

            var cb:InputElement = cast Browser.document.createElement('input');
            cb.type = "checkbox";
            cb.checked = _defaultRewriteEnabled;
            cb.defaultChecked = _defaultRewriteEnabled;
            cb.id = uuid;
            cb.addEventListener('change', activeRewriteHandler);

            var label:LabelElement = cast Browser.document.createElement('label');
            label.htmlFor = uuid;
            label.innerText = "Active Rewrite";

            groupElement.appendChild(cb);
            groupElement.appendChild(label);

            formHead.append(new JQuery(groupElement));
        }
    }

    /**
     *  Check if textarea is a comment in github
     *  @param elem -
     */
    private function isCommentTextArea(elem:TextAreaElement)
    {
        var response:Bool = false;
        if (
            elem.className.indexOf(ElementId.COMMENT_FORM) >= 0 ||
            elem.id == ElementId.RELEASE_PAGE ||
            elem.id == ElementId.PULL_REQUEST_BODY
        ) {
            response = true;
        }

        return response;
    }

    /**
     *  Catch When click on rewrite on/off
     *  @param event -
     */
    private function activeRewriteHandler(event:Dynamic)
    {
        var cb:InputElement = cast event.target || event.srcElement;
        var txtArea:TextAreaElement = cast Browser.document.querySelector('textarea.gob_' +  cb.id);

        setRewriteFeature(txtArea, cb.checked);

        if (cb.checked) {
            replaceTextareaContentHandler(txtArea);
        }
    }
}
