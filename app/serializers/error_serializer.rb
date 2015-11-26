require 'securerandom'

module ErrorSerializer
  def ErrorSerializer.serialize(errors)
    return if errors.nil?

    json = {}
    new_hash = errors.to_hash.map do |key, message|
      {
        id: SecureRandom.uuid,
        title: message.join(". ") + "."
      }
    end.flatten
    # set the json root and return
    json[:errors] = new_hash
    json
   end
 end
=begin
  JSON API spec errors
 {
   "errors": [
     {
       "id": "name",
       "title": "Name cannot be empty"
     } // ...
   ]
 }
=end
