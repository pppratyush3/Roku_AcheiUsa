sub init()
    m.buttons = m.top.findNode("detailScreenButton")
    m.buttons.buttons = ["Watch now", "Add to playlist"]
    m.video = m.top.findNode("detailScreenVideo")
    m.buttons.observeField("buttonSelected", "playVideo")

    m.top.setFocus(true)
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false

    if key = "right" or key = "left"
        print "key==?"
        print key
        print m.buttons
        if m.buttons.buttonFocused = 0
            m.buttons.buttonFocused = 1
        else
            m.buttons.focusButton = 0
        end if
        result = true
    else if key = "back"
        print "back"
        m.video.control = "stop"
        m.video.visible = false
        result = true
    end if
    return result
end function

function playVideo(msg as object)
    if type(msg) = "roSGNodeEvent" and msg.getField() = "buttonSelected"
        if msg.getData() = 0

            videocontent = createObject("RoSGNode", "ContentNode")
            videocontent.title = m.top.videoTitle
            videocontent.url = m.global.videoLink
            m.video.content = videocontent
            m.video.visible = true
            print "m.top.videoTitle"
            print m.top.videoTitle
            print "m.global.videoLink"
            print m.global.videoLink

        end if
    end if
end function
