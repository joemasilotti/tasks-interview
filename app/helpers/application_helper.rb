module ApplicationHelper
  def flash_class(type)
    class_names(
      "mb-4 p-3 border rounded",
      "bg-red-50 border-red-300 text-red-800": type == "alert",
      "bg-gray-50 border-gray-300 text-gray-800": type != "alert"
    )
  end
end
