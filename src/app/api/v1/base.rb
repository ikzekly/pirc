module V1
  class Base < Grape::API
    mount V1::Test
  end
end