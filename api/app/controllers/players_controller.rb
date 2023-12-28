class PlayersController < ApplicationController
    def index
        render status: 200, json: { body: "players list" }
    end
end
