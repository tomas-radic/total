class Player::BaseController < ApplicationController

  before_action :authenticate_player!

end
