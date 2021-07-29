import rospy
from std_msgs.msg import String
from pytimedinput import timedInput

from the_mainest.srv import Give, GiveResponse


class CVCommander(object):

    def __init__(self) -> None:
        super().__init__()
        
        self.mode = 'inference'

        self.mode_pub = rospy.Publisher('/command_from_human', String, queue_size=1)
        rospy.Service('/give', Give, self.commander_handler)

    def commander_handler(self, req):
        rospy.loginfo(f"Select working mode for segmentation algorithm: from `{self.mode}` to `{req.mode}`")
        
        self.mode = req.mode.data
        rospy.loginfo(self.mode)

        # TODO how is it work?
        # if 'train' in self.mode:
        #     rospy.loginfo(f"train mode! Enter ")
        #     userText, timedOut = timedInput('', timeOut=15)
        #     if(timedOut):
        #         rospy.loginfo('changing mode to inference')
        #         self.mode = 'inference'
        #     else:
        #         self.mode = userText

        self.mode_pub.publish(self.mode)
    
        return []

    def spin(self):
        rate = rospy.Rate(10)
        while not rospy.is_shutdown():
            rate.sleep()


def main():
    rospy.init_node('commands_cl', anonymous=False)

    cv_commander = CVCommander()
    
    try:
        cv_commander.spin()
    except rospy.ROSInterruptException as e:
        rospy.logerr(e)


if __name__ == '__main__':
    main()
