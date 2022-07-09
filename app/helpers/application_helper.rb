module ApplicationHelper
    def cp(path)
        return true if current_page?(path)
    end
end
