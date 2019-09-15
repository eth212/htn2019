import tensorflow as tf
import cv2
import argparse
import os
import matplotlib
from matplotlib import pyplot as plt
import numpy as np


import posenet


parser = argparse.ArgumentParser()
parser.add_argument('--model', type=int, default=101)
parser.add_argument('--scale_factor', type=float, default=1.0)
parser.add_argument('--notxt', action='store_true')
parser.add_argument('--image_dir', type=str, default='./--image_dir')
parser.add_argument('--output_dir', type=str, default='./output')
args = parser.parse_known_args()[0]


def main():
    print("What side of your body are you filming? r/l")
    side = input()
    if side == "l":
        side = True #filming the left side
    else:
        side = False #filming the right side

    with tf.Session() as sess:
        model_cfg, model_outputs = posenet.load_model(args.model, sess)
        output_stride = model_cfg['output_stride']

        if args.output_dir:
            if not os.path.exists(args.output_dir):
                os.makedirs(args.output_dir)

        filenames = [
            f.path for f in os.scandir(args.image_dir) if f.is_file() and f.path.endswith(('.png', '.jpg'))]


        for f in filenames:
            input_image, draw_image, output_scale = posenet.read_imgfile(
                f, scale_factor=args.scale_factor, output_stride=output_stride)

            heatmaps_result, offsets_result, displacement_fwd_result, displacement_bwd_result = sess.run(
                model_outputs,
                feed_dict={'image:0': input_image}
            )

            pose_scores, keypoint_scores, keypoint_coords = posenet.decode_multiple_poses(
                heatmaps_result.squeeze(axis=0),
                offsets_result.squeeze(axis=0),
                displacement_fwd_result.squeeze(axis=0),
                displacement_bwd_result.squeeze(axis=0),
                output_stride=output_stride,
                max_pose_detections=10,
                min_pose_score=0.25)

            keypoint_coords *= output_scale












        if not args.notxt:
            print("Results for image: %s" % f)
            #manual scores
            manual_keypoint_scores = [[]]
            manual_keypoint_coords = [[]]
            for pi in range(len(pose_scores)):
                if pose_scores[pi] == 0.:
                    break
                print('Score = %f' % ( pose_scores[pi]))
                manual_pose_score = [pose_scores[pi]]
                #ki is keypoint index, s = score, c = coord
                for ki, (s, c) in enumerate(zip(keypoint_scores[pi, :], keypoint_coords[pi, :, :])):

                    print('Keypoint %s, score = %f, coord = %s' % (posenet.PART_NAMES[ki], s, c))
                    if side == True:
                        if (posenet.PART_NAMES[ki] == "leftEye"):
                            Leye = (posenet.PART_NAMES[ki], s, c)
                            print('Collected by scrapper Keypoint %s, score = %f, coord = %s' % Leye)
                        elif (posenet.PART_NAMES[ki] == "leftShoulder"):
                            Lshoulder = (posenet.PART_NAMES[ki], s, c)
                            print('Collected by scrapper Keypoint %s, score = %f, coord = %s' % Lshoulder)
                        elif (posenet.PART_NAMES[ki] == "leftHip"):
                            Lhip = (posenet.PART_NAMES[ki], s, c)
                            print('Collected by scrapper Keypoint %s, score = %f, coord = %s' % Lhip)
                        elif (posenet.PART_NAMES[ki] == "leftKnee"):
                            Lknee = (posenet.PART_NAMES[ki], s, c)
                            print('Collected by scrapper Keypoint %s, score = %f, coord = %s' % Lknee)
                        elif (posenet.PART_NAMES[ki] == "leftAnkle"):
                            Lankle = (posenet.PART_NAMES[ki], s, c)
                            print('Collected by scrapper Keypoint %s, score = %f, coord = %s' % Lankle)


                    elif side == False:

                        if (posenet.PART_NAMES[ki] == "rightEye"):
                            Reye = (posenet.PART_NAMES[ki], s, c)
                            Reye_score = s.tolist()
                            Reye_coord = c.tolist()
                            manual_keypoint_scores[pi].append(Reye_score)
                            manual_keypoint_coords[pi].append(Reye_coord)
                            print('Collected by scrapper Keypoint %s, score = %f, coord = %s' % Reye)
                        elif (posenet.PART_NAMES[ki] == "rightShoulder"):
                            Rshoulder = (posenet.PART_NAMES[ki], s, c)
                            Rshoulder_score = s.tolist()
                            Rshoulder_coord = c.tolist()
                            manual_keypoint_scores[pi].append([Rshoulder_score])
                            manual_keypoint_coords[pi].append([Rshoulder_coord])
                            print('Collected by scrapper Keypoint %s, score = %f, coord = %s' % Rshoulder)
                        elif (posenet.PART_NAMES[ki] == "rightHip"):
                            Rhip = (posenet.PART_NAMES[ki], s, c)
                            Rhip_score = s.tolist()
                            Rhip_coord = c.tolist()
                            manual_keypoint_scores[pi].append([Rhip_score])
                            manual_keypoint_coords[pi].append([Rhip_coord])
                            print('Collected by scrapper Keypoint %s, score = %f, coord = %s' % Rhip)
                        elif (posenet.PART_NAMES[ki] == "rightKnee"):
                            Rknee = (posenet.PART_NAMES[ki], s, c)
                            Rknee_score = s.tolist()
                            Rknee_coord = c.tolist()
                            print(Rknee_coord)
                            print(Rknee_score)
                            manual_keypoint_scores[pi].append([Rknee_score])
                            manual_keypoint_coords[pi].append([Rknee_coord])
                            print('Collected by scrapper Keypoint %s, score = %f, coord = %s' % Rknee)
                        elif (posenet.PART_NAMES[ki] == "rightAnkle"):
                            Rankle = (posenet.PART_NAMES[ki], s, c)
                            Rankle_score = s.tolist()
                            Rankle_coord = c.tolist()
                            manual_keypoint_scores[pi].append([Rankle_score])
                            manual_keypoint_coords[pi].append([Rankle_coord])
                            print('Collected by scrapper Keypoint %s, score = %f, coord = %s' % Rankle)
            print(manual_keypoint_coords)
            print(manual_keypoint_scores)
            print(keypoint_coords)
            print(keypoint_scores)
            if args.output_dir:
                draw_image = posenet.draw_skel_and_kp(
                    draw_image, pose_scores, keypoint_scores, keypoint_coords,
                    min_pose_score=0.25, min_part_score=0.25)

                cv2.imwrite(os.path.join(args.output_dir, os.path.relpath(f, args.image_dir)), draw_image)



if __name__ == "__main__":
    main()
