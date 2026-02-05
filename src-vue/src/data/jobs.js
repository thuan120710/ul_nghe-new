export const jobsList = [
  {
    id: 'lankhobau',
    name: 'THỢ MỎ',
    description: 'Thợ mỏ sẽ đưa công dân nhập vai vào một anh thợ mỏ chính hiệu, tích lũy sức lao động để khai thác các loại khoáng sản quý giá từ lòng đất.',
    image: '/image/thomo.png',
    icon: '/image/cuoc.png',
    videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', // Link YouTube video hướng dẫn
    requirements: {
      level: 'IC + 10%',
      exp: 'EXP - 10%',
      difficulty: 'Dễ dàng'
    },
    rewards: [
      { icon: '/image/kinhnghiem.png', name: 'Kinh nghiệm' },
      { icon: '/image/tienkhoa.png', name: 'Tiền khóa' },
      { icon: '/image/dasach.png', name: 'Đá sạch' },
      { icon: '/image/dongtho.png', name: 'Đồng thô' },
      { icon: '/image/bactho.png', name: 'Bạc thô' },
      { icon: '/image/vangtho.png', name: 'Vàng thô' },
      { icon: '/image/kimcuong.png', name: 'Kim cương' }
    ],
    tools: [
      { icon: '/image/cuoc1.png', name: 'Cây cuốc' }
    ],
    guide: {
      title: 'Hướng dẫn:',
      description: 'Sử dụng [E] để thực hiện đào đá (Mỗi lần hoàn thành đào đá sẽ nhận được 1 tích lũy đào đá)',
      steps: [
        '1. Sau khi làm xong, chọn "Nhận thưởng" để nhận thưởng và "Kết thúc công việc" để ngừng làm việc Đến Khu Nung Đá và sử dụng [E] để thực hiện nung đá (Cần 20 đá thô cho mỗi lần nung) Bán sản phẩm tại Chợ Đầu Mối hoặc dùng cho chế tạo Lưu ý:  - Công dân có thể tích lũy tối đa 180 lần đào đá / 1 lần nhận thưởng (khoảng 1 giờ làm việc nhận thưởng 1 lần) - Số lần tích lũy đào đá sẽ làm mới sau mỗi lần cúp điện/bảo trì định kỳ - Luôn đảm bảo túi đồ có đủ ô và kg trước khi nhận thưởng.'
      ]
    },
    skills: {
      current: 'Cấp độ nghề hiện tại',
      level: 'LEVEL 1',
      exp: 5600,
      maxExp: 12000,
      nextLevel: 5,
      maxLevel: 25,
      description: 'Tích lũy đủ điểm nghề và Level của bạn để nâng cấp nghề. Khi nâng cấp nghề bạn sẽ được nhận thêm phần thưởng, thu nhập và EXP khi làm nghề.'
    }
  }
]

export const getJobById = (id) => {
  return jobsList.find(job => job.id === id) || jobsList[0]
}
