module Api
  module V1
    class BaseController < ApplicationController
      include Knock::Authenticable
    end
  end
end