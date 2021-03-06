class ApplicationPolicy

  class Scope

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user
        if user.admin?
          scope.all
        else
          scope.where(user_id: user.id)
        end
      else
        scope.where('1 = 2')
      end
    end

  end

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    scope
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    user
  end

  def new?
    create?
  end

  def update?
    is_owner_or_admin?
  end

  def edit?
    update?
  end

  def destroy?
    is_owner_or_admin?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  protected

  def is_admin?
    user.try(:admin?) || false
  end

  def is_owner_or_admin?
    is_owned_by?(user) || is_admin?
  end

  def is_owned_by?(user)
    user.present? && record.user == user
  end

end
