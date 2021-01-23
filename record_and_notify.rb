require 'discordrb'
require 'open-uri'
require 'screen-recorder'
require 'open3'
require 'json'

bot = Discordrb::Commands::CommandBot.new(
  token: ENV['TOKEN'],
  client_id: ENV['CLIENT_ID'],
  prefix: '/'
)
channel_id = 549143999814959124#test
# channel_id = 449149979861319691#production


loop do
  sleep 1
  replay_names = Dir::entries("replays")
  if replay_names.size > 2
    replays_ctime = {}
    replay_names.each do |replay_name|
      unless replay_name == "." or replay_name == ".."
        replays_ctime["#{replay_name}"] = File.ctime("./replays/#{replay_name}")
      end
    end
    target_replay = replays_ctime.min{ |x, y| x[1] <=> y[1] }[0]
    p target_replay
    system "start ./replays/#{target_replay}"
    advanced = {f: 'dshow', i: 'audio="ステレオ ミキサー (Realtek High Definition Audio)"'}
    @recorder = ScreenRecorder::Window.new(title: 'WoT Blitz', output: "replay.mp4", advanced: advanced)

    sleep 20
    @recorder.start
    p "start recording"
    # sleep 30
    sleep 450
    p "stop recording"
    @recorder.stop
    system "taskkill /im wotblitz.exe /f"
    # system "python upload_video.py --file='test.MP4' \ --title='Sample Movie' \ --description='This is a sample movie.' \ --category='22' \ --privacyStatus='private'"

    tempHash = {
      "title" => "#{target_replay}",
    }
    File.open("metadata.json","w") do |f|
      f.write(tempHash.to_json)
      f.close
    end
    upload_command = "python upload.py"
    p "start upload"
    stdin, stdout, stderr = Open3.capture3(upload_command)
    p "#{stdin}"
    if stdin == "error"
      bot.send_message(channel_id,"unable to upload to youtube")
    else
      bot.send_message(channel_id,"https://www.youtube.com/watch?v=#{stdin}")
    end
    File.delete("./replays/#{target_replay}")
  end
end
bot.run
