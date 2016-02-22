class MessageBlastJob < ActiveJob::Base
    queue_as :default

    def perform args
        sender = User.find(args[:id])
        messages = ['สวัสดีทุกคน

เรามาบอกเกี่ยวกับรายระเอียด
ของงานปาร์ตี้ที่มัลดีฟส์ในวันพรุ่งนี้

เรามีดีเจมาเพิ่มอีก 2 คน
เพื่อให้งานสนุกยิ่งขึ้น
แล้วมัลดีฟส์ก็เพิ่งอัพเกรด
ผับข้างหลังทันเวลางานของเราพอดี!',
'OMG แล้วก็สาวสวยรวมถึง
พริตตี้มากกว่า 50 คน
งานนี้เริ่มจะHot ขึ้นเรื่อยๆแล้ว

อัพเกรดเป็นเมมเบอร์ Silver หรือ Gold 
ก่อนที่จะถึงงาน
จะได้ผลประโยชน์มากมาย!!!',

'เปิดให้เข้างาน 19:00
อาหารบุฟเฟต์ 20:00
กรรมการแมวมอง 21:00
ดีเจขึ้น 22:00
สนุกกันให้เต็มที่ 24:00

ตรีมเสื้อผ้า ดำแดง นะคะ',
'Hey Everyone !!!

Party at Maldives is Saturday

DRESS CODE:
Red and Black (dress to impress)

We just got 2 new Dj’s
Maldives has upgraded their
dance club lighting just in time for us!',

'OMG !!! More than 50 Pretty are coming.
Things are getting hot !!!

Doors open at 7pm
Buffet is at 8pm
Secret Talent Scout 9pm
Dj 10pm
Party till 12am',

'Upgrade to Silver or Gold before
the event to get the benefits

Want to upgrade to Maldives Special &
walk into this party for free?
Ask Jasmine in the chats screen']
        User.all.each do |user|
            next if user.id == sender.id
            chat = Chat.joins(:participants).where(participants: { user_id: [sender.id, user.id] }).group(:id).having('count(chats.id) > 1').first

            if chat.nil?
                chat = Chat.create!(participants_attributes: [
                    { user_id: user.id },
                    { user_id: sender.id }
                ])
            end
            next if chat.nil?
            messages.each do |message_text|
                Message.create!(chat_id: chat.id,
                    text: message_text,
                    user_id: sender.id)
            end
        end
    end
end
