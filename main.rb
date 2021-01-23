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

bot.ready do
  # system "ruby record_and_notify.rb"
end

bot.message(in: channel_id) do |event|
  p "message detected"
  files = event.message.attachments
  if not files.empty?
    file = files[0]
    file_name = file.filename
    file_url = file.url

    open(file_url) do |file|
      open("./replays/#{file_name}", "w+b") do |out|
        out.write(file.read)
      end
    end
  end
end
bot.run
