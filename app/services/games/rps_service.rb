module Games
  class RpsService
    include RpsLogger

    BASE_URL = 'https://5eddt4q9dk.execute-api.us-east-1.amazonaws.com/rps-stage/throw'

    RESULT_PHRASES = {
      tie: 'TIE...still better than loosing',
      win: 'VICTORY :) CONGRATS!!',
      lose: 'LOSE :( better luck next time'
    }

    attr_reader :game_result, :error_message

    def initialize(throw)
      @player_option ||= throw[:throw].to_sym
    end

    def call
      unless RockPaperScissor::OPTIONS.include?(@player_option)
        @error_message = "The option is not valid. Retry with one of these: #{RockPaperScissor::OPTIONS.join(' or ')}"
        return false
      end

      @game_result = score

      true

    rescue StandardError => e
      log_error(e.message)
      @error_message = e.message
      return false
    end

    private

      def server_throw
        @server_option ||= (
          response = Faraday.get(BASE_URL, { 'Accept' => 'application/json' })
          response_body = JSON.parse(response.body, symbolize_names: true)
          server_option = response_body['body']&.to_sym
          server_option.nil? ? RockPaperScissor::OPTIONS[rand(3)] : server_option)
      end

      def rules(key)
        {
          rock: :scissors,
          scissors: :paper,
          paper: :rock,
        }[key]
      end

      def score
        "You sent #{@player_option} and the api throw was #{server_throw}. So it resulted in a #{result}!"
      end

      def result
        if @player_option == @server_option
          RESULT_PHRASES[:tie]
        elsif rules(@player_option) == @server_option
          RESULT_PHRASES[:win]
        else
          RESULT_PHRASES[:lose]
        end
      end
  end
end