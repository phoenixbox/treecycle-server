module ErrorSerializer
  def ErrorSerializer.serialize(errors)
    return if errors.nil?

    json = {}
    new_hash = errors.to_hash(true).map do |key, message|
      {
        id: key,
        title: message.join(". ") + "."
      }
    end.flatten
    # set the json root and return
    json[:errors] = new_hash
    json
   end
 end
