module Api
  module V1
    class BaseController < ApplicationController
      include ExceptionsHandler
    end
  end
end
