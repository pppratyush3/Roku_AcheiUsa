sub init()
    m.buttons = m.top.findNode("detailScreenButton")
    m.buttons.buttons = ["Watch now", "Add to playlist"]
    m.buttons.observeField("buttonSelected", "playVideo")
    m.video = m.top.findNode("detailScreenVideo")
    m.video.observeField("state", "onVideoStateChanged")
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if key = "right" or key = "left"
        if m.buttons.buttonFocused = 0
            m.buttons.buttonFocused = 1
        else
            m.buttons.focusButton = 0
        end if
        result = true
    else if key = "back"
        m.buttons.focusButton = 0
        if m.video.visible
            m.video.control = "stop"
            m.video.visible = false
            result = true
            m.top.SetFocus(true)
        else
            result = false
        end if
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
            m.video.control = "play"
            m.video.setFocus(true)

        end if
    end if
end function

function onVideoStateChanged(msg as object)
    if type(msg) = "roSGNodeEvent" and msg.getField() = "state"
        if msg.getData() = "finished"
            m.video.visible = "false"
            m.video.control = "stop"
        end if
    end if
end function