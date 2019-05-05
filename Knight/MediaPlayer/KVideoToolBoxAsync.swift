//
//  KVideoToolBoxAsync.swift
//  Knight
//
//  Created by 陈志鹏 on 2018/8/8.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import Foundation

import CoreMedia
import CoreFoundation
import CoreVideo.CVHostTime
import Foundation
import Darwin.C.stdatomic
import VideoToolbox

//public var MAX_PKT_QUEUE_DEEP: Int32 { get }
//public var VTB_MAX_DECODING_SAMPLES: Int32 { get }
//
//public struct sample_info {
//
//    public var sample_id: Int32
//
//
//    public var sort: Double
//
//    public var dts: Double
//
//    public var pts: Double
//
//    public var serial: Int32
//
//
//    public var sar_num: Int32
//
//    public var sar_den: Int32
//
//
//    public var is_decoding: Int32
//
//    public init()
//
//    public init(sample_id: Int32, sort: Double, dts: Double, pts: Double, serial: Int32, sar_num: Int32, sar_den: Int32, is_decoding: Int32)
//}
//
//public struct sort_queue {
//
//    public var pic: AVFrame
//
//    public var serial: Int32
//
//    public var sort: Int64
//
//    public var nextframe: UnsafeMutablePointer<sort_queue>!
//
//    public init()
//
//    public init(pic: AVFrame, serial: Int32, sort: Int64, nextframe: UnsafeMutablePointer<sort_queue>!)
//}
//
//public struct VTBFormatDesc {
//
//
//    public var fmt_desc: Unmanaged<CMFormatDescription>!
//
//    public var max_ref_frames: Int32
//
//    public var convert_bytestream: Bool
//
//    public var convert_3byteTo4byteNALSize: Bool
//
//    public init()
//
//    public init(fmt_desc: Unmanaged<CMFormatDescription>!, max_ref_frames: Int32, convert_bytestream: Bool, convert_3byteTo4byteNALSize: Bool)
//}
//
//public struct Ijk_VideoToolBox_Opaque {
//
//    public var ffp: UnsafeMutablePointer<FFPlayer>!
//
//    public var refresh_request: Bool
//
//    public var new_seg_flag: Bool
//
//    public var idr_based_identified: Bool
//
//    public var refresh_session: Bool
//
//    public var recovery_drop_packet: Bool
//
//
//    public var codecpar: UnsafeMutablePointer<AVCodecParameters>!
//
//    public var fmt_desc: VTBFormatDesc
//
//    public var vt_session: Unmanaged<VTDecompressionSession>!
//
//    public var m_queue_mutex: pthread_mutex_t
//
//    public var m_sort_queue: UnsafeMutablePointer<sort_queue>!
//
//    public var m_queue_depth: Int32
//
//    public var serial: Int32
//
//    public var dealloced: Bool
//
//    public var m_buffer_deep: Int32
//
//    public var m_buffer_packet: (AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket, AVPacket)
//
//
//    public var sample_info_mutex: UnsafeMutablePointer<SDL_mutex>!
//
//    public var sample_info_cond: UnsafeMutablePointer<SDL_cond>!
//
//    public var sample_info_array: (sample_info, sample_info, sample_info)
//
//    public var sample_info_index: Int32
//
//    public var sample_info_id_generator: Int32
//
//    public var sample_infos_in_decoding: Int32
//
//
//    public var sampler: SDL_SpeedSampler
//}
//
//public func vtbformat_destroy(_ fmt_desc: UnsafeMutablePointer<VTBFormatDesc>!)
//public func vtbformat_init(_ fmt_desc: UnsafeMutablePointer<VTBFormatDesc>!, _ codecpar: UnsafeMutablePointer<AVCodecParameters>!) -> Int32
//
//public func vtb_get_error_string(_ status: OSStatus) -> UnsafePointer<Int8>!
//
//public func SortQueuePop(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!)
//
//public func CFDictionarySetSInt32(_ dictionary: CFMutableDictionary!, _ key: CFString!, _ numberSInt32: Int32)
//
//public func CFDictionarySetBoolean(_ dictionary: CFMutableDictionary!, _ key: CFString!, _ value: Bool)
//
//public func sample_info_flush(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!, _ wait_ms: Int32)
//
//public func sample_info_peek(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!) -> UnsafeMutablePointer<sample_info>!
//
//public func sample_info_push(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!)
//
//public func sample_info_drop_last_push(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!)
//
//public func sample_info_recycle(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!, _ sample_info: UnsafeMutablePointer<sample_info>!)
//
//public func CreateSampleBufferFrom(_ fmt_desc: CMFormatDescription!, _ demux_buff: UnsafeMutableRawPointer!, _ demux_size: Int) -> Unmanaged<CMSampleBuffer>!
//
//public func GetVTBPicture(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!, _ pVTBPicture: UnsafeMutablePointer<AVFrame>!) -> Bool
//
//public func QueuePicture(_ ctx: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!)
//
//public func VTDecoderCallback(_ decompressionOutputRefCon: UnsafeMutableRawPointer!, _ sourceFrameRefCon: UnsafeMutableRawPointer!, _ status: OSStatus, _ infoFlags: VTDecodeInfoFlags, _ imageBuffer: CVImageBuffer!, _ presentationTimeStamp: CMTime, _ presentationDuration: CMTime)
//
//// FIXME: duplicated code
//
//// drop too late frame
//
////ALOGI("%lf %lf %lf \n", newFrame->sort,newFrame->pts, newFrame->dts);
////ALOGI("display queue deep %d\n", ctx->m_queue_depth);
//
////ALOGI("depth %d  %d\n", ctx->m_queue_depth, ctx->m_max_ref_frames);
//
//public func vtbsession_destroy(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!)
//
//public func vtbsession_create(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!) -> Unmanaged<VTDecompressionSession>!
//
//public func decode_video_internal(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!, _ avctx: UnsafeMutablePointer<AVCodecContext>!, _ avpkt: UnsafePointer<AVPacket>!, _ got_picture_ptr: UnsafeMutablePointer<Int32>!) -> Int32
//
//// ALOGI("flag :%d flag %d \n", decoderFlags,avpkt->flags);
//
//// ALOGI("the buffer should m_convert_byte\n");
//
//// ALOGI("demux_size:%d\n", demux_size);
//
//// ALOGI("3byteto4byte\n");
//
//// Wait for delayed frames even if kVTDecodeInfo_Asynchronous is not set.
//
//public func ResetPktBuffer(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!)
//
//public func DuplicatePkt(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!, _ pkt: UnsafePointer<AVPacket>!)
//
//public func decode_video(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!, _ avctx: UnsafeMutablePointer<AVCodecContext>!, _ avpkt: UnsafeMutablePointer<AVPacket>!, _ got_picture_ptr: UnsafeMutablePointer<Int32>!) -> Int32
//
//// minimum avcC(sps,pps) = 7
//
//public func dict_set_string(_ dict: CFMutableDictionary!, _ key: CFString!, _ value: UnsafePointer<Int8>!)
//
//public func dict_set_boolean(_ dict: CFMutableDictionary!, _ key: CFString!, _ value: Bool)
//
//public func dict_set_object(_ dict: CFMutableDictionary!, _ key: CFString!, _ value: UnsafeMutablePointer<Unmanaged<CFTypeRef>?>!)
//
//public func dict_set_data(_ dict: CFMutableDictionary!, _ key: CFString!, _ value: UnsafeMutablePointer<UInt8>!, _ length: UInt64)
//
//public func dict_set_i32(_ dict: CFMutableDictionary!, _ key: CFString!, _ value: Int32)
//
//public func CreateFormatDescriptionFromCodecData(_ format_id: CMVideoCodecType, _ width: Int32, _ height: Int32, _ extradata: UnsafePointer<UInt8>!, _ extradata_size: Int32, _ atom: UInt32) -> Unmanaged<CMFormatDescription>!
//
///* CVPixelAspectRatio dict */
//
///* SampleDescriptionExtensionAtoms dict */
//
///* Extensions dict */
//
//public func videotoolbox_async_free(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!)
//
//public func videotoolbox_async_decode_frame(_ context: UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!) -> Int32
//
//// Apple A7 SoC
//// Hi10p can be decoded into NV12 ('420v')
//
//// Fallback on earlier versions
//
////                if (!validate_avcC_spc(extradata, extrasize, &fmt_desc->max_ref_frames, &sps_level, &sps_profile)) {
////goto failed;
////                }
//
//public func videotoolbox_async_create(_ ffp: UnsafeMutablePointer<FFPlayer>!, _ avctx: UnsafeMutablePointer<AVCodecContext>!) -> UnsafeMutablePointer<Ijk_VideoToolBox_Opaque>!
