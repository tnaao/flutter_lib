//
//  Constant.swift
//  Runner
//
//  Created by nguon pisey on 2/8/21.
//

import Foundation
struct Constant {
    static let MP_VIEW_TYPE = "player_cross_platform"

    static let METHOD_CHANNEL_PLAYER = "METHOD_CHANNEL_PLAYER"
    static let EVENT_CHANNEL_PLAYER = "EVENT_CHANNEL_PLAYER"
    static let EVENT_CHANNEL_PERCENTAGE_DOWNLOADED = "EVENT_CHANNEL_PERCENTAGE_DOWNLOADED"
    static let EVENT_CHANNEL_DOWNLOAD_STATUS = "EVENT_CHANNEL_DOWNLOAD_STATUS"

    static let METHOD_PLAY = "METHOD_PLAY"
    static let METHOD_PAUSE = "METHOD_PAUSE"
    static let METHOD_RESTART = "METHOD_RESTART"

    static let METHOD_GET_LIST_QUALITY_VIDEO = "METHOD_GET_QUALITY_VIDEO"
    static let METHOD_GET_DURATION_STATE = "METHOD_GET_DURATION_STATE"
    static let METHOD_SEEK_TO = "METHOD_SEEK_TO"
    static let METHOD_START_DOWNLOAD = "METHOD_START_DOWNLOAD"
    static let METHOD_CANCEL_DOWNLOAD = "METHOD_CANCEL_DOWNLOAD"
    static let METHOD_CHECK_IS_DOWNLOAD = "METHOD_CHECK_IS_DOWNLOAD"
    static let METHOD_CHANGE_QUALITY = "METHOD_CHANGE_QUALITY"
    static let METHOD_CHANGE_PLAYBACK_SPEED = "METHOD_CHANGE_PLAYBACK_SPEED"
    static let METHOD_CHANGE_SUBTITLE = "METHOD_CHANGE_SUBTITLE"
    static let METHOD_IS_PLAYING = "METHOD_IS_PLAYING"

    static let KEY_WIDTH = "KEY_WIDTH"
    static let KEY_HEIGHT = "KEY_HEIGHT"
    static let KEY_BITRATE = "KEY_BITRATE"
    static let KEY_URL_QUALITY = "KEY_URL_QUALITY"

    static let KEY_PLAY_WHEN_READY = "KEY_PLAY_WHEN_READY"
    static let KEY_PLAYER_RESOURCE = "KEY_PLAYER_RESOURCE"
    static let KEY_TITLE_MOVIE = "KEY_TITLE_MOVIE"
    static let KEY_URL_MOVIE = "KEY_URL_MOVIE"
    static let KEY_TRACK_INDEX = "KEY_TRACK_INDEX"

    static let KEY_SUBTITLE_LABEL = "KEY_SUBTITLE_LABEL"
    static let KEY_SUBTITLE_INDEX = "KEY_SUBTITLE_INDEX"

    static let KEY_CURRENT_POSITION = "KEY_CURRENT_POSITION"
    static let KEY_TOTAL_DURATION = "KEY_TOTAL_DURATION"
    static let KEY_BUFFER_UPDATE = "KEY_BUFFER_UPDATE"
    
    static let KEY_EVENT_TYPE = "KEY_EVENT_TYPE"
    static let KEY_VALUE_OF_EVENT = "KEY_VALUE_OF_EVENT";

    static let EVENT_PROGRESS_DOWNLOAD = "EVENT_PROGRESS_DOWNLOAD"
    static let EVENT_DOWNLOAD_STARTED = "EVENT_DOWNLOAD_STARTED"
    static let EVENT_DOWNLOAD_PAUSED = "EVENT_DOWNLOAD_PAUSED"
    static let EVENT_DOWNLOAD_RESUMED = "EVENT_DOWNLOAD_RESUMED"
    static let EVENT_DOWNLOAD_COMPLETED = "EVENT_DOWNLOAD_COMPLETED"
    static let EVENT_DOWNLOAD_FAILED = "EVENT_DOWNLOAD_FAILED"
    static let EVENT_DOWNLOAD_CANCELED = "EVENT_DOWNLOAD_CANCELED"

    static let EVENT_READY_TO_PLAY = "EVENT_READY_TO_PLAY"
    static let EVENT_PLAY = "EVENT_PLAY"
    static let EVENT_PAUSE = "EVENT_PAUSE"
    static let EVENT_LOADING = "EVENT_LOADING"
    static let EVENT_FINISH = "EVENT_FINISH"

}
