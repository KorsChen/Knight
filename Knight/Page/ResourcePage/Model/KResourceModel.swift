//
//  LHMyFriendModel.swift
//  leihou
//
//  Created by 陈志鹏 on 2018/5/17.
//  Copyright © 2018 huajiao. All rights reserved.
//

import Foundation

class KResourceModel
{
    var videoArray = [KResourceItem]()
    var chinaArray = [KResourceItem]()
    var foreignArray = [KResourceItem]()

    init() {
        setupChinaData()
        setupVideoArray()
        foreignData()
    }
    
    func setupChinaData() {
//轩巨子二兔
        chinaArray.append(KResourceItem(nickname: "轩巨子二兔",
                                        avator: "https://tvax3.sinaimg.cn/crop.0.0.1414.1414.180/6ebedee6ly8fs3aauj2mlj215o13jx49.jpg",
                                        introduce: "[女仆场景]~助眠",
                                        url: "http://static.missevan.com/MP3/201704/30/53a1cdb9b33d472ed7fe5136075c5f35230358.mp3"))
        
        chinaArray.append(KResourceItem(nickname: "轩巨子二兔",
                                        avator: "https://tvax3.sinaimg.cn/crop.0.0.1414.1414.180/6ebedee6ly8fs3aauj2mlj215o13jx49.jpg",
                                        introduce: "[心里电台]~3D同人声",
                                        url: "http://static.missevan.com/MP3/201704/30/7a607d04d6401e5c441a6bf30e5f84a1225828.mp3"))

        chinaArray.append(KResourceItem(nickname: "轩巨子二兔",
                                        avator: "https://tvax3.sinaimg.cn/crop.0.0.1414.1414.180/6ebedee6ly8fs3aauj2mlj215o13jx49.jpg",
                                        introduce: "[邻家姐姐的特别服务]～3D同人声",
                                        url: "http://static.missevan.com/MP3/201704/24/4d184197aa5bbe02b3811a0030072fa9201115.mp3"))

        chinaArray.append(KResourceItem(nickname: "轩巨子二兔",
                                        avator: "https://tvax3.sinaimg.cn/crop.0.0.1414.1414.180/6ebedee6ly8fs3aauj2mlj215o13jx49.jpg",
                                        introduce: "[女仆场景]～3D同人声",
                                        url: "http://static.missevan.com/MP3/201704/24/2e2583be56e692eadef70536ff99416e193749.mp3"))

        chinaArray.append(KResourceItem(nickname: "轩巨子二兔",
                                        avator: "https://tvax3.sinaimg.cn/crop.0.0.1414.1414.180/6ebedee6ly8fs3aauj2mlj215o13jx49.jpg",
                                        introduce: "[冰镇掏耳朵]～3D耳骚",
                                        url: "http://static.missevan.com/MP3/201704/24/e289bc94f4e421f2afb2b242d07fb0d2192924.mp3"))

        chinaArray.append(KResourceItem(nickname: "轩巨子二兔",
                                        avator: "https://tvax3.sinaimg.cn/crop.0.0.1414.1414.180/6ebedee6ly8fs3aauj2mlj215o13jx49.jpg",
                                        introduce: "[可爱的老婆喝醉酒撒娇]～3D同人声",
                                        url: "http://static.missevan.com/MP3/201704/24/e289bc94f4e421f2afb2b242d07fb0d2192924.mp3"))

//双马尾馨儿
        chinaArray.append(KResourceItem(nickname: "双马尾馨儿",
                                          avator: "https://tvax1.sinaimg.cn/crop.0.0.750.750.180/80639abcly8fmq5y4ux41j20ku0kumyq.jpg",
                                          introduce: "[催眠冥想]~等你走进我的梦里",
                                          url: "http://static.missevan.com/MP3/201707/03/0cc7c19eb26a6f827580b721c00c59a4165239.mp3"))
        chinaArray.append(KResourceItem(nickname: "双马尾馨儿",
                                          avator: "https://tvax1.sinaimg.cn/crop.0.0.750.750.180/80639abcly8fmq5y4ux41j20ku0kumyq.jpg",
                                          introduce: "[助眠]~耳朵服侍",
                                          url: "http://static.missevan.com/MP3/201707/03/d63b49e556c3b1e5cb2175b3ff27cd60164021.mp3"))
        chinaArray.append(KResourceItem(nickname: "双马尾馨儿",
                                          avator: "https://tvax1.sinaimg.cn/crop.0.0.750.750.180/80639abcly8fmq5y4ux41j20ku0kumyq.jpg",
                                          introduce: "[不怎么正经的吃水果]",
                                          url: "http://static.missevan.com/MP3/201705/06/6de414af48e3c0c8299374fd797c4386171504.mp3"))
        chinaArray.append(KResourceItem(nickname: "双马尾馨儿",
                                          avator: "https://tvax1.sinaimg.cn/crop.0.0.750.750.180/80639abcly8fmq5y4ux41j20ku0kumyq.jpg",
                                          introduce: "[吃土的日常]",
                                          url: "http://static.missevan.com/MP3/201705/06/6de414af48e3c0c8299374fd797c4386171504.mp3"))
        chinaArray.append(KResourceItem(nickname: "双马尾馨儿",
                                          avator: "https://tvax1.sinaimg.cn/crop.0.0.750.750.180/80639abcly8fmq5y4ux41j20ku0kumyq.jpg",
                                          introduce: "[按摩]~助眠",
                                          url: "http://static.missevan.com/MP3/201612/28/8751a82cb1e86b23535185a791dd2713121053.mp3"))
        
//清软喵
        chinaArray.append(KResourceItem(nickname: "清软喵",
                                        avator: "https://tva1.sinaimg.cn/crop.0.0.1328.1328.180/005Dr4Z8jw8fcb3g78af7j310w10wn0t.jpg",
                                        introduce: "[安稳哄睡]",
                                        url: "http://static.missevan.com/MP3/201709/12/cce7078cc8e53ebd937a1778e32fcccc032328.mp3"))
        chinaArray.append(KResourceItem(nickname: "清软喵",
                                        avator: "https://tva1.sinaimg.cn/crop.0.0.1328.1328.180/005Dr4Z8jw8fcb3g78af7j310w10wn0t.jpg",
                                        introduce: "[聊天]",
                                        url: "http://static.missevan.com/MP3/201709/12/586106bbb08c947da5d4cdda2717ac91032444.mp3"))
        chinaArray.append(KResourceItem(nickname: "清软喵",
                                        avator: "https://tva1.sinaimg.cn/crop.0.0.1328.1328.180/005Dr4Z8jw8fcb3g78af7j310w10wn0t.jpg",
                                        introduce: "[一起吃面]",
                                        url: "http://static.missevan.com/MP3/201802/05/2b100a9e930a2f497de21a52a6486862200120.mp3"))
    }
    
    func foreignData() {
        foreignArray.append(KResourceItem(nickname: "未知",
                                        avator: "https://tva1.sinaimg.cn/crop.133.0.873.873.180/9d76492bjw8ex8vcdc7u8j20sg0o9jxc.jpg",
                                        introduce: "[帮你洗头]~助眠",
                                        url: "http://static.missevan.com//128BIT/201807/28/0202494e836173d123b9a9936553ab24115353.mp3"))
        
        foreignArray.append(KResourceItem(nickname: "未知",
                                        avator: "https://tva1.sinaimg.cn/crop.0.0.258.258.180/bdb9798egw1ek43iknd7rj2077077wf0.jpg",
                                        introduce: "[耳部按摩]",
                                        url: "http://static.missevan.com//128BIT/201707/16/6594a1fc203cfb9a011fa764563ff3fa065859.mp3"))
        
        foreignArray.append(KResourceItem(nickname: "未知",
                                        avator: "https://tvax1.sinaimg.cn/crop.302.42.355.355.180/60e97c23ly8firpi63msij20m80f8wis.jpg",
                                        introduce: "[耳道清洁]",
                                        url: "http://static.missevan.com//MP3/201704/19/5f9e2c165a96fe113ef8ee7b5a244968213619.mp3"))
        
        foreignArray.append(KResourceItem(nickname: "未知",
                                        avator: "https://tva1.sinaimg.cn/crop.133.0.873.873.180/9d76492bjw8ex8vcdc7u8j20sg0o9jxc.jpg",
                                        introduce: "[夜晚的安眠]",
                                        url: "http://static.missevan.com//128BIT/201701/08/c649603d17073426221e57653ee4a6a9192813.mp3"))
        
        foreignArray.append(KResourceItem(nickname: "未知",
                                        avator: "https://tva1.sinaimg.cn/crop.0.0.258.258.180/bdb9798egw1ek43iknd7rj2077077wf0.jpg",
                                        introduce: "[口腔音呼吸]",
                                        url: "http://static.missevan.com//MP3/201611/16/3bd74f2ed417b8919dfe1ce28136f1bf224902.mp3"))
        
        foreignArray.append(KResourceItem(nickname: "喵娘",
                                        avator: "https://tvax2.sinaimg.cn/crop.0.0.736.736.180/bb9adb57ly8frhgzlsm90j20kg0kgq52.jpg",
                                        introduce: "[喵娘]",
                                        url: "http://static.missevan.com//128BIT/201705/08/5f9e2673285de25eff5ea493efaa9e11021321.mp3"))
    }
    
    func setupVideoArray() {
        videoArray.append(KResourceItem(nickname: "日出",
                                        avator: "https://tvax4.sinaimg.cn/crop.12.23.178.178.1024/00706Llcly8fnib3cvvxkj305g06ogli.jpg",
                                        introduce: "[航拍]",
                                        url: "http://wm.video.huajiao.com/vod-wm-huajiao-bj/142382470_4-1531857389-fb076dbc-f140-0dc7.mp4"))
        
        videoArray.append(KResourceItem(nickname: "电音",
                                        avator: "http://img5.duitang.com/uploads/item/201402/23/20140223125156_GAaFF.jpeg",
                                        introduce: "[技术流]",
                                        url: "http://wm.video.huajiao.com/vod-wm-huajiao-bj/137012790_4-1530019999-4765cea2-983f-a82e.mp4"))
        
        videoArray.append(KResourceItem(nickname: "洗脑歌",
                                        avator: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532949341186&di=b3a8ea6b76f7090b079bd794d27d6d25&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201508%2F24%2F20150824104140_HaF43.thumb.224_0.png",
                                        introduce: "[女警]",
                                        url: "http://wm.video.huajiao.com/vod-wm-huajiao-bj/126710535_4-1527109851-51d23b88-ff15-94ab.mp4"))
        
        videoArray.append(KResourceItem(nickname: "爵士",
                                        avator: "https://tvax1.sinaimg.cn/crop.0.0.1024.1024.180/a6d71762ly8fhdz2k2x0xj20sg0sg3zq.jpg",
                                        introduce: "[爵士]",
                                        url: "http://wm.video.huajiao.com/vod-wm-huajiao-bj/137589439_4-1530255213-3cb06889-4565-0272.mp4"))
        
        videoArray.append(KResourceItem(nickname: "Sweet",
                                        avator: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532949368286&di=bf87e202052955b37e0a43124aa16ab9&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201411%2F07%2F20141107170613_8Awxn.png",
                                        introduce: "[girl]",
                                        url: "http://wm.video.huajiao.com/vod-wm-huajiao-bj/78891132_4-1514882648-ed4711f8-38c8-36f3.mp4"))
        
        videoArray.append(KResourceItem(nickname: "热舞",
                                        avator: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532949368286&di=bf87e202052955b37e0a43124aa16ab9&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201411%2F07%2F20141107170613_8Awxn.png",
                                        introduce: "[star]",
                                        url: "http://wm.video.huajiao.com/vod-wm-huajiao-bj/141881670_4-1531545048-3a605e4f-cd3b-6021.mp4"))
        
        videoArray.append(KResourceItem(nickname: "特效",
                                        avator: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532949469523&di=2c5c48dc1398e253a1010b9a4cdd32a8&imgtype=0&src=http%3A%2F%2Fwww.qqzhi.com%2Fuploadpic%2F2014-06-09%2F181456452.jpg",
                                        introduce: "双胞胎",
                                        url: "http://wm.video.huajiao.com/vod-wm-huajiao-bj/143737163_4-1532676429-259d1da2-855a-bb39.mp4"))

        videoArray.append(KResourceItem(nickname: "吃到最后",
                                        avator: "https://tvax4.sinaimg.cn/crop.12.23.178.178.1024/00706Llcly8fnib3cvvxkj305g06ogli.jpg",
                                        introduce: "[萌宠]",
                                        url: "http://wm.video.huajiao.com/vod-wm-huajiao-bj/140061570_4-1530946719-078f31be-36d4-c11f.mp4"))
        
        videoArray.append(KResourceItem(nickname: "日韩",
                                        avator: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532949749738&di=82fbec661613c9b864b15d6ec1a95c17&imgtype=0&src=http%3A%2F%2Fwww.qqzhi.com%2Fuploadpic%2F2015-01-21%2F022515690.jpg",
                                        introduce: "[舞]",
                                        url: "http://wm.video.huajiao.com/vod-wm-huajiao-bj/100336365_4-1520856276-0168d303-2952-6f6a.mp4"))
        
        videoArray.append(KResourceItem(nickname: "海藻",
                                        avator: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532949469523&di=2c5c48dc1398e253a1010b9a4cdd32a8&imgtype=0&src=http%3A%2F%2Fwww.qqzhi.com%2Fuploadpic%2F2014-06-09%2F181456452.jpg",
                                        introduce: "双胞胎",
                                        url: "http://wm.video.huajiao.com/vod-wm-huajiao-bj/114611169_4-1524011719-22820fb2-892d-a19a.mp4"))
        
        videoArray.append(KResourceItem(nickname: "凤尾竹",
                                        avator: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532950001959&di=c5ac0122c70cc0e8d55b81351823f682&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201601%2F08%2F20160108100924_z8ULV.jpeg",
                                        introduce: "[乐器]",
                                        url: "http://wm.video.huajiao.com/vod-wm-huajiao-bj/130116615_4-1528188312-a96d6111-f494-d1f4.mp4"))
    }
}
