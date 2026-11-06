module SessionsHelper
  def dev_login_value(value)
    value if Rails.env.development? && action_name == "new"
  end
end
