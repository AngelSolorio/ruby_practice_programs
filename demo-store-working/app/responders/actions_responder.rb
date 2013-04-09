class ActionsResponder < ActionController::Responder
  EXCLUDE_ACTION = [:new, :show, :edit]

  delegate :flash, :render, :redirect_to,   :to => :controller

  def initialize(controller, resources, options = {})
    super

    @alert = options.delete(:alert)
    @notice = options.delete(:notice)
    @flash_now = options.delete(:flash_now) || false
    has_flash = options.delete(:flash)
    @flash = has_flash.nil? ? true : has_flash
    @location = options.delete(:location)
  end

  def to_html
    set_alert_flash_message if !get? && has_errors? && @flash
    set_notice_flash_message if @flash

    response = calculate_response
    super unless response.present?
  end

protected
  def calculate_response
    return redirect_to @location if @location

    self.send "#{controller.action_name}_action".to_sym unless EXCLUDE_ACTION.include?(controller.action_name.to_sym)
  end

  def create_action
    response = nil

    response = if post? && has_errors?
      render :new
    elsif post? && !has_errors?
      redirect_to navigate_path
    end

    response
  end

  def update_action
    response = nil

    response = if (put? || patch?) && has_errors?
      render :edit
    elsif (put? || patch?) && !has_errors?
      redirect_to navigate_path
    end

    response
  end

  def set_alert_flash_message
    set_flash :alert, @alert || translate_message('alert')
  end

  def set_notice_flash_message
    translated = translate_message('notice') if !get? && !@notice.present?
    message = @notice || translated
    set_flash :notice, message if message.present?
  end

  def set_flash(key, message)
    return controller.flash.now[key] = message if @flash_now
    flash[key] = message
  end

  def navigate_path
    namespace = controller.controller_path.split('/')
    namespace << 'path'
    path = namespace.join('_')

    controller.send path
  end

  def translate_message(scope)
    namespace = controller.controller_path.split('/')
    namespace << scope
    namespace << controller.action_name

    lookups = Array namespace.join('.')
    lookups << "action.#{scope}.#{controller.action_name}".to_sym

    I18n.t(lookups.shift, scope: :flash,
      default: lookups,
      resource: resource.class.model_name.human)
  end
end
