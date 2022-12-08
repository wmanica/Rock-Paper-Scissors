class Api::RpsController < ApplicationController

  def play
    service = Games::RpsService.new(player_params)

    unless service.call
      render status: :bad_request,
             json: { error: service.error_message }
    end and return

    render status: :ok,
           json: { result: service.game_result }
  end

  private

    def player_params
      params.require(:player_throw).permit(:throw)
    end
end
