module SlackUtil
  def self.post(channel, text, attachment = nil)
    return if channel.nil? || text.nil?

    uri = URI('https://slack.com/api/chat.postMessage')
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)

    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{ENV['SLACK_API_KEY']}"
    request['Connection'] = 'keep-alive'

    param = {
      channel: channel,
      text: text,
      username: 'sweets_pos',
      icon_url: 'https://i.imgur.com/2aIp3nS.png'
    }

    param = param.merge(attachments: attachment) unless attachment.nil?

    request.body = param.to_json

    response = http.request(request)
    puts response.read_body
  end
end
