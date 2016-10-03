module GENYMOTION
  class DeviceManager
    class << self
      def device_ids
        `VBoxManage list vms | awk '{print $(NF)}' | sed 's/[{}]//g'`.split
      end

      def devices
        `VBoxManage list vms`
      end

      def launch(device)
        p "launching #{device}"
        player = GENYMOTION.player_app.nil? ? '/Applications/Genymotion.app/Contents/MacOS/player.app/Contents/MacOS/player' : GENYMOTION.player_app
        `#{player} --vm-name #{device} &`
      end

      def adb_devices
        `adb devices | tail -n +2 | awk '{print $1}'`.split
      end

      def device_running?(device)
        `adb -s #{device} shell getprop sys.boot_completed`.to_i == 1
      end

      def kill_all
        `ps -ef | grep '[p]layer' | awk '{print $2}' | xargs kill`
        `ps -ef | grep '[V]BoxHeadless' | awk '{print $2}' | xargs kill`
      end

      def all_devices_operational?
        return false if adb_devices.nil? || adb_devices.empty?
        adb_devices.select { |d| !device_running?(d) }.empty?
      end
    end
  end
end