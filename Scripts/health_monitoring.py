
import psutil
import time

def main():
    # Open log file for writing
    with open("health_monitor.txt", "w") as f:
        while True:
            # Get network usage statistics
            net_io_counters = psutil.net_io_counters()
            bytes_sent = net_io_counters.bytes_sent
            bytes_recv = net_io_counters.bytes_recv

            # Get CPU usage statistics
            cpu_percent = psutil.cpu_percent()

            # Get memory usage statistics
            virtual_memory = psutil.virtual_memory()
            mem_used_percent = virtual_memory.percent

            # Get uptime statistics
            uptime_seconds = int(time.time() - psutil.boot_time())
            uptime_minutes = int(uptime_seconds / 60)
            uptime_hours = int(uptime_minutes / 60)
            uptime_days = int(uptime_hours / 24)

            # Write statistics to log file
            f.write(f"Bytes sent: {bytes_sent}\n")
            f.write(f"Bytes received: {bytes_recv}\n")
            f.write(f"CPU usage: {cpu_percent}%\n")
            f.write(f"Memory usage: {mem_used_percent}%\n")
            f.write(f"Uptime: {uptime_days} days, {uptime_hours % 24} hours, {uptime_minutes % 60} minutes, {uptime_seconds % 60} seconds\n")
            f.write("\n")

            # Wait for 1 second before checking again
            time.sleep(1)

if __name__ == "__main__":
    main()
