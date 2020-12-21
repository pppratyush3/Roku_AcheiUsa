sub Init()
    m.global.addField("obj", "assocarray", false)
    m.top.functionName = "fetchData"
end sub

function fetchData()
    url = CreateObject("roUrlTransfer")
    url.SetCertificatesFile("common:/certs/ca-bundle.crt")
    url.AddHeader("X-Roku-Reserved-Dev-Id", "")
    url.InitClientCertificates()
    url.SetUrl("https://hosttec.online/rokuxml/achei/achei.json")
    data = url.GetToString()
    if data <> invalid and data <> ""
        parsedData = ParseJSON(data)
        formateData(parsedData)
    end if
end function

function formateData(parsedData as object)
    rootContentNode = CreateObject("roSGNode", "RowListContent")
    mediaIndex = {}
    m.obj = {
        "categories": [{
            name: "AcheiUSA Newspaper - Parte 02",
            playlistName: "achei02",
            video: []
        }, {
            name: "AcheiUSA Newspaper - Parte 01",
            playlistName: "achei01",
            video: []
        }]
    }

    for each category in parsedData.categories

        childNode = rootContentNode.CreateChild("ContentNode")
        childNode.title = category.name
        for each tvSpecial in parsedData.tvSpecials
            for each playlist in parsedData.playlists
                if playlist.name = category.playlistName
                    for each id in playlist.itemIds
                        if tvSpecial.id = id
                            for each video in tvSpecial.content.videos
                                gChild = childNode.CreateChild("ContentNode")
                                gChild.title = video.Title
                                gChild.HDPosterUrl = tvSpecial.thumbnail
                                mediaIndex[tvSpecial.id] = {
                                    id: tvSpecial.id,
                                    url: video.url
                                }
                                if category.playlistName = "achei02"
                                    m.obj.categories[0].video.push({
                                        "url": video.url,
                                        "quality": video.quality,
                                        "mainTitle": tvSpecial.title,
                                        "thumbnail": tvSpecial.thumbnail,
                                        "date": tvSpecial.content.dateAdded,
                                        "quality": video.quality,
                                        "duration": tvSpecial.content.duration,
                                        "shortDescription": tvSpecial.shortDescription,
                                        "title": tvSpecial.title,
                                    })
                                else
                                    m.obj.categories[1].video.push({
                                        "url": video.url,
                                        "quality": video.quality,
                                        "mainTitle": tvSpecial.title,
                                        "thumbnail": tvSpecial.thumbnail,
                                        "date": tvSpecial.content.dateAdded,
                                        "quality": video.quality,
                                        "duration": tvSpecial.content.duration,
                                        "shortDescription": tvSpecial.shortDescription,
                                        "title": tvSpecial.title,
                                    })
                                end if
                            end for
                        end if
                    end for
                end if
            end for
        end for
    end for

    m.global.obj = m.obj

    m.top.content = rootContentNode
    m.top.mediaIndex = mediaIndex

end function