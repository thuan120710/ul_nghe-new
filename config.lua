QBCore = exports['qb-core']:GetCoreObject()

Config = {}

-- Helper function để lấy stats từ f17-ttvl
local function GetTTVLStats(jobName)
    local success, stats = pcall(function()
        return exports['f17-ttvl']:GetJobStats(jobName)
    end)
    
    if success and stats then
        -- Chuyển đổi từ format TTVL sang format UI
        -- TTVL format: stats[1].taskProgress = tiền, stats[2].taskProgress = exp, stats[3].taskProgress = active
        return {
            money = { 
                current = stats.money.current or 0, 
                target = stats.money.target or 60 
            },
            exp = { 
                current = stats.exp.current or 0, 
                target = stats.exp.target or 200 
            },
            active = { 
                current = stats.active.current or 0, 
                target = stats.active.target or 20 
            }
        }
    else
        print(string.format("^1[ERROR] GetTTVLStats(%s): Failed to get stats^7", jobName))
        -- Fallback nếu không tìm thấy trong TTVL
        return {
            money = { current = 0, target = 60 },
            exp = { current = 0, target = 200 },
            active = { current = 0, target = 20 }
        }
    end
end

-- Helper function để lấy rewards từ f17-ttvl
local function GetTTVLRewards(jobName)
    local success, rewards = pcall(function()
        return exports['f17-ttvl']:GetJobRewards(jobName)
    end)
    
    if success and rewards then
        print(string.format("^2[DEBUG] GetTTVLRewards(%s): Found %d rewards^7", jobName, #rewards))
        return rewards
    else
        print(string.format("^1[ERROR] GetTTVLRewards(%s): Failed to get rewards^7", jobName))
        return {}
    end
end

-- Helper function để lấy requirements từ f17-ttvl
local function GetTTVLRequirements(jobName)
    local success, requirements = pcall(function()
        return exports['f17-ttvl']:GetJobRequirements(jobName)
    end)
    
    if success and requirements then
        print(string.format("^2[DEBUG] GetTTVLRequirements(%s): Found %d requirements^7", jobName, #requirements))
        return requirements
    else
        print(string.format("^1[ERROR] GetTTVLRequirements(%s): Failed to get requirements^7", jobName))
        return {}
    end
end

Config.JobsMenu = {
  ['vesinh'] = {
    name = "VỆ SINH",
    requiredLevel = 1,
    maxLevel = 1,
    hasLevel = false,
    toolImage = "vesinh2.png",  -- Ảnh công cụ nghề
    home = {
        title = "TRANG CHỦ",
        description = "Vệ sinh là nghề Co-Op đầu tiên trong thành phố, mang đến trải nghiệm làm việc nhóm thú vị. Các công dân có thể tạo đội để cùng dọn dẹp và giữ gìn môi trường thành phố."..
        "<br><br><b>Hình thức:</b>"..
        "<br>- Cá nhân: Nhận được nhiều tiền và kinh nghiệm hơn, thời gian làm lâu hơn"..
        "<br>- Co-Op (2 – 4 người): Tốc độ làm việc nhanh, kinh nghiệm và tiền chia đều cho các thành viên trong tổ đội"..
        "<br><br><b>Đặc điểm:</b>"..
        "<br>- Tiền & kinh nghiệm tăng giảm theo biến động việc làm."..
        "<br>- Có thể chế được vật phẩm hoạt động (vật phẩm cần thiết về sau).",
        process = GetTTVLStats("vesinh"),
        img = "vesinh.png"
    },
    guide = {
        title = "HƯỚNG DẪN",
        description = "<b>Hướng dẫn:</b>"..
        "<br>1. Bắt đầu công việc (tổ đội tối đa 4 người)"..
        "<br>2. Lái xe rác và di chuyển đến khu vực chỉ định trên bản đồ"..
        "<br>3. Sử dụng [E] để thu gôm rác tại các thùng rác trong khu vực và đưa vào xe rác"..
        "<br>4. Thu gôm đủ số túi rác yêu cầu và quay về gặp NPC để 'Nhận thưởng' và 'Nhận lượt mới'"..
        "<br><br><b>Lưu ý:</b>"..
        "<br>- Chọn 'Nhận thưởng' khi đã thu thập đủ túi rác yêu cầu."..
        "<br>- Chọn 'Nhận lượt mới' sau khi nhận thưởng để bắt đầu lượt mới.",
        videoID = "7WVeIhbCrdE",
        img = "vesinh.png"
    },
    careerLevel = {},
    start = {
        isPopup = false,
        isSidebar = true,
        msg = "Bạn đang làm",
    },
    isTeamwork = false,
    isCanBuy = false,
    rewards = GetTTVLRewards("vesinh"),
    requirements = GetTTVLRequirements("vesinh"),
    acceptJob = {
      eventname = 'f17_vesinh:cl:DoJob',
      eventtype = 'client'
    },
    cancelJob = {
      eventname = 'f17_vesinh:cl:CancelJob',
      eventtype = 'client'
    },
    upgradeJob = {},
    button = {
      otherbtn = {
        {
          buttonname = 'Nhận thưởng',
          eventname = 'f17_vesinh:cl:rewardVeSinh',
          eventtype = 'client'
        }, {
          buttonname = 'Nhận lượt mới',
          eventname = 'f17_vesinh:cl:takeNewRoute',
          eventtype = 'client'
        }
      }
    }
  },
  ['xaydung'] = {
    name = "XÂY DỰNG",
    requiredLevel = 1,
    maxLevel = 3,
    hasLevel = true,
    toolImage = "xaydung",  -- Tên base, sẽ tự động thêm level
    home = {
        title = "TRANG CHỦ",
        description = "Xây dựng là nghề cốt lõi tại F17CITY, nơi cả newbie và oldbie đều tìm thấy cơ hội phát triển. Đây là nghề kiếm tiền IC và XP ổn định nhất, với công việc dễ dàng và không đòi hỏi quá nhiều kỹ năng."..
        "<br><br><b>Hình thức:</b>"..
        "<br>- Cá nhân: Cực kỳ dễ tiếp cận, thích hợp cho newbie lẫn oldbie"..
        "<br><br><b>Đặc điểm:</b>"..
        "<br>- Tiền & kinh nghiệm tăng giảm theo biến động việc làm."..
        "<br>- Có hệ thống cấp độ nghề riêng, level càng cao bạn càng kiếm được nhiều tiền và kinh nghiệm."..
        "<br>- Thay đổi vị trí làm việc mỗi cấp độ.",
        process = GetTTVLStats("xaydung"),
        img = "xaydung.png"
    },
    guide = {
        title = "HƯỚNG DẪN",
        description = "<b>Hướng dẫn:</b>"..
        "<br>1. Bắt đầu công việc"..
        "<br>2. Sử dụng [E] tại các điểm chỉ định để làm việc"..
        "<br><br><b>Lưu ý:</b>"..
        "<br>- Sau khi hoàn thành hết các điểm chỉ định, hệ thống sẽ tự tính toán trả thưởng và đưa các điểm làm việc mới."..
        "<br>- Nếu muốn dừng công việc, công dân về gặp NPC chọn 'Kết thúc công việc'.",
        videoID = "rkSqq0j6enY",
        img = "xaydung.png"
    },
    careerLevel = {
        title = "CẤP ĐỘ NGHỀ",
        name = "XÂY DỰNG",
        progress = 0,
        target1 = 1400,
        level1 = 30,
        target2 = 2800,
        level2 = 65,
        img = "xaydung.png"
    },
    start = {
        isPopup = false,
        isSidebar = true,
        msg = "Bạn đang làm",
    },
    isTeamwork = false,
    isCanBuy = false,
    rewards = GetTTVLRewards("xaydung"),
    requirements = GetTTVLRequirements("xaydung"),
    acceptJob = {
      eventname = 'f17_xaydung:cl:DoJob',
      eventtype = 'client'
    },
    cancelJob = {
      eventname = 'f17_xaydung:cl:CancelJob',
      eventtype = 'client'
    },
    upgradeJob = {
      eventname = 'f17_xaydung:cl:NangCapNghe',
      eventtype = 'client'
    },
    button = {}
  },
  ['thomo'] = {
    name = "THỢ MỎ",
    requiredLevel = 1,
    maxLevel = 3,
    hasLevel = true,
    toolImage = "cuoc",  -- Tên base, sẽ tự động thêm level
    home = {
        title = "TRANG CHỦ",
        description = "Thợ mỏ sẽ đưa công dân nhập vai vào một anh thợ mỏ chính hiệu, tích lũy sức lao động để khai thác các loại khoáng sản quý giá từ lòng đất."..
        "<br><br><b>Hình thức:</b>"..
        "<br>- Cá nhân: Cực kỳ dễ tiếp cận"..
        "<br><br><b>Đặc điểm:</b>"..
        "<br>- Có Minigame tương tác"..
        "<br>- Kinh nghiệm & giá khoáng sản tăng giảm theo biến động việc làm và biến động chợ đầu mối"..
        "<br>- Đá sạch là nguyên liệu thiết yếu cho chế tạo, thường có giá cao do nhu cầu lớn"..
        "<br><br><b>Lưu ý:</b>"..
        "<br>- Công dân có thể tích luỹ tối đa 180 lần đào đá / 1 lần nhận thưởng (khoảng 1 giờ làm việc nhận thưởng 1 lần)."..
        "<br>- Số lần tích lũy đào đá sẽ làm mới sau mỗi lần cúp điện/bảo trì định kỳ."..
        "<br>- Luôn đảm bảo túi đồ có đủ ô và kg trước khi nhận thưởng.",
        process = GetTTVLStats("thomo"),
        img = "thomo.png"
    },
    guide = {
        title = "HƯỚNG DẪN",
        description = "<b>Hướng dẫn:</b>"..
        "<br>1. Bắt đầu công việc"..
        "<br>2. Đến Khu Đào Đá và sử dụng [E] để thực hiện đào đá (Mỗi lần hoàn thành đào đá sẽ nhận được 1 tích luỹ đào đá)"..
        "<br>3. Sau khi làm xong, chọn 'Nhận thưởng' để nhận thưởng và 'Kết thúc công việc' để ngừng làm việc"..
        "<br>4. Đến Khu Nung Đá và sử dụng [E] để thực hiện nung đá (Cần 20 đá thô cho mỗi lần nung)"..
        "<br>5. Bán sản phẩm tại Chợ Đầu Mối hoặc dùng cho chế tạo"..
        "<br><br><b>Lưu ý:</b>"..
        "<br>- Luôn đảm bảo túi đồ có đủ ô và kg trước khi nhận thưởng.",
        videoID = "oo40Ig2jsWA",
        img = "thomo.png"
    },
    careerLevel = {
        title = "CẤP ĐỘ NGHỀ",
        name = "THỢ MỎ",
        progress = 0,
        target1 = 12000,
        level1 = 35,
        target2 = 24000,
        level2 = 70,
        img = "thomo.png"
    },
    start = {
        isPopup = false,
        isSidebar = true,
        msg = "Bạn đang làm",
    },
    isTeamwork = false,
    isCanBuy = false,
    rewards = GetTTVLRewards("thomo"),
    requirements = GetTTVLRequirements("thomo"),
    acceptJob = {
      eventname = 'f17_thomo:cl:DoJob',
      eventtype = 'client'
    },
    cancelJob = {
      eventname = 'f17_thomo:cl:CancelJob',
      eventtype = 'client'
    },
    upgradeJob = {
      eventname = 'f17_thomo:cl:NangCapNghe',
      eventtype = 'client'
    },
    button = {
      otherbtn = {
        {
          buttonname = 'Nhận thưởng',
          eventname = 'f17_thomo:cl:rewardDaoDa',
          eventtype = 'client'
        }  
      }
    }
  },
  ['nuoithu'] = {
    name = "NUÔI THÚ",
    requiredLevel = 5,
    maxLevel = 1,
    hasLevel = false,
    toolImage = "nuoithu2.png",  -- Ảnh công cụ nghề
    home = {
      title = "TRANG CHỦ",
      description = "Nơi bạn sẽ tự tay chăm sóc thú nuôi của mình cho đến khi trưởng thành và mang chúng đi bán tại Chợ Đầu Mối. Công việc này kết hợp giữa 50% active và 50% auto."..
      "<br><br><b>Hình thức:</b>"..
      "<br>- Cá nhân: Nhẹ nhàng dễ dàng, phù hợp cho người đang bận việc OOC mà vẫn có tiền IC"..
      "<br><br><b>Đặc điểm:</b>"..
      "<br>- Kinh nghiệm & giá vật phẩm nghề tăng giảm theo biến động việc làm và biến động chợ đầu mối",
      process = GetTTVLStats("nuoithu"),
      img = "nuoithu.png"
    },
    guide = {
        title = "HƯỚNG DẪN",
        description = "<b>Hướng dẫn:</b>"..
        "<br>1. Bắt đầu công việc"..
        "<br>2. Sử dụng '(Nuôi thú) Trứng' để thả thú ra và dùng '(Nuôi thú) Food' để cho thú ăn"..
        "<br>3. Chờ thú trưởng thành và thu hoạch sau đó mang đi bán tại Chợ Đầu Mối"..
        "<br><br><b>Lưu ý:</b>"..
        "<br>- Mua '(Nuôi thú) Trứng' và '(Nuôi thú) Food' tại Tạp hoá.",
        "<br>- Nếu để thú nuôi chết bạn sẽ bị tăng rất nhiều stress.",
        "<br>- Nếu muốn dừng công việc, công dân về gặp NPC chọn 'Kết thúc công việc'.",
        videoID = "rrNg3IXr-S0",
        img = "nuoithu.png"
    },
    careerLevel = {},
    start = {
        isPopup = false,
        isSidebar = true,
        msg = "Bạn đang làm",
    },
    isTeamwork = false,
    isCanBuy = false,
    rewards = GetTTVLRewards("nuoithu"),
    requirements = GetTTVLRequirements("nuoithu"),
    acceptJob = {
      eventname = 'f17_cstc:cl:DoJob',
      eventtype = 'client'
    },
    cancelJob = {
      eventname = 'f17_cstc:cl:CancelJob',
      eventtype = 'client'
    },
    upgradeJob = {},
    button = {}
  },
  ['food'] = {
    name = "GRAB FOOD",
    requiredLevel = 10,
    maxLevel = 3,
    hasLevel = true,
    toolImage = "grabfood",  -- Tên base, sẽ tự động thêm level
    home = {
        title = "TRANG CHỦ",
        description = "Bạn sẽ nhập vai thành một tài xế Grab Food, lái xe khắp thành phố để giao những đơn hàng ngẫu nhiên."..
        "<br><br><b>Hình thức:</b>"..
        "<br>- Cá nhân: Nhẹ nhàng dễ dàng, phù hợp cho người thích lái xe"..
        "<br><br><b>Đặc điểm:</b>"..
        "<br>- Tiền & kinh nghiệm tăng giảm theo biến động việc làm."..
        "<br>- Có hệ thống cấp độ nghề riêng, level càng cao bạn càng kiếm được nhiều tiền và kinh nghiệm."..
        "<br>- Nghề có lời thoại NPC đa dạng - phong phú."..
        "<br>- Khi tăng cấp độ nghề, xe food sẽ thay đổi nâng cấp nhanh hơn - đẹp hơn.",
        process = GetTTVLStats("grabfood"),
        img = "food.png"
    },
    guide = {
        title = "HƯỚNG DẪN",
        description = "<b>Hướng dẫn:</b>"..
        "<br>1. Bắt đầu công việc"..
        "<br>2. Sử dụng [U] để đợi nổ đơn"..
        "<br>3. Lấy đơn hàng và di chuyển đến vị trí khách hàng được đánh dấu trên bản đồ"..
        "<br>4. Lặp lại B2 để tiếp tục công việc"..
        "<br><br><b>Lưu ý:</b>"..
        "<br>- Nếu muốn dừng công việc, hoàn thành hết chuyến và về gặp NPC chọn 'Kết thúc công việc' (không được lặp lại B2)",
        videoID = "T_iRUZpBFw0",
        img = "food.png"
    },
    careerLevel = {
        title = "CẤP ĐỘ NGHỀ",
        name = "GRAB FOOD",
        progress = 0,
        target1 = 700,
        level1 = 40,
        target2 = 1400,
        level2 = 75,
        img = "food.png"
    },
    start = {
        isPopup = false,
        isSidebar = true,
        msg = "Bạn đang làm",
    },
    isTeamwork = false,
    isCanBuy = false,
    rewards = GetTTVLRewards("food"),
    requirements = GetTTVLRequirements("food"),
    acceptJob = {
      eventname = 'f17_grabfood:cl:DoJob',
      eventtype = 'client'
    },
    cancelJob = {
      eventname = 'f17_grabfood:cl:CancelJob',
      eventtype = 'client'
    },
    upgradeJob = {
      eventname = 'f17_grabfood:cl:NangCapNghe',
      eventtype = 'client'
    },
    button = {}
  },
  ['thodien'] = {
    name = "THỢ ĐIỆN",
    requiredLevel = 10,
    maxLevel = 1,
    hasLevel = false,
    toolImage = "thodien1.png",  -- Ảnh công cụ nghề
    home = {
        title = "TRANG CHỦ",
        description = "Bạn sẽ nhập vai thành một anh thợ điện, lái xe đến các điểm sửa chữa điện trong khắp thành phố. Đây là công việc mang lại thu nhập ổn định mà còn là con đường nhanh nhất để bạn kiếm XP."..
        "<br><br><b>Hình thức:</b>"..
        "<br>- Cá nhân: Dễ dàng tiếp cận"..
        "<br><br><b>Đặc điểm:</b>"..
        "<br>- Tiền & kinh nghiệm tăng giảm theo biến động việc làm."..
        "<br>- Tiền & kinh nghiệm tăng theo level nghề.",
        process = GetTTVLStats("thodien"),
        img = "thodien.png"
    },
    guide = {
        title = "HƯỚNG DẪN",
        description = "<b>Hướng dẫn:</b>"..
        "<br>1. Bắt đầu công việc"..
        "<br>2. Di chuyển đến vị trí trụ điện được đánh dấu trên bản đồ"..
        "<br>3. Hoàn thành các công việc yêu cầu tại trụ điện"..
        "<br>4. Lặp lại B2 để tiếp tục công việc"..
        "<br><br><b>Lưu ý:</b>"..
        "<br>- Nếu muốn dừng công việc, hoàn thành hết chuyến và về gặp NPC chọn 'Kết thúc công việc'",
        videoID = "OgWCGRW833A",
        img = "thodien.png"
    },
    careerLevel = {},
    start = {
        isPopup = false,
        isSidebar = true,
        msg = "Bạn đang làm",
    },
    isTeamwork = false,
    isCanBuy = false,
    rewards = GetTTVLRewards("thodien"),
    requirements = GetTTVLRequirements("thodien"),
    acceptJob = {
      eventname = 'f17_thodien:cl:DoJob',
      eventtype = 'client'
    },
    cancelJob = {
      eventname = 'f17_thodien:cl:CancelJob',
      eventtype = 'client'
    },
    upgradeJob = {},
    button = {}
  },
  ['ngheauto'] = {
    name = "NGHỀ AUTO",
    requiredLevel = 10,
    maxLevel = 5,
    hasLevel = true,
    home = {
        title = "TRANG CHỦ",
        description = "Nghề auto với cơ chế auto lên tới 99% (1% còn lại là phải bán thủ công tại Chợ Đầu Mối)"..
        "<br><br><b>Hình thức:</b>"..
        "<br>- Cá nhân: Phù hợp cho người đang bận việc OOC mà vẫn có tiền IC"..
        "<br><br><b>Đặc điểm:</b>"..
        "<br>- Có hệ thống cấp độ nghề riêng, level càng cao bạn càng kiếm được nhiều vật phẩm."..
        "<br>- Giá vật phẩm tăng giảm theo biến động chợ đầu mối."..
        "<br>- Vật phẩm kiếm được từ nghề có thể bán lại cho doanh nghiệp hoặc để chế tạo vật phẩm khác."..
        "<br>- Khi treo auto sẽ được giảm 50% thời gian trừ đói - khát.",
        process = GetTTVLStats("ngheauto"),
        img = "ngheauto.png"
    },
    guide = {
        title = "HƯỚNG DẪN",
        description = "<b>Hướng dẫn:</b>"..
        "<br>1. Bắt đầu công việc"..
        "<br>2. Di chuyển đến khu vực chỉ định để treo auto"..
        "<br>3. Mang vật phẩm thành phẩm đi bán tại Chợ Đầu Mối (Cần 20 vật phẩm)",
        "<br><br><b>Lưu ý:</b>"..
        "<br>- Nếu muốn dừng công việc, hoàn thành hết chuyến và về gặp NPC chọn 'Kết thúc công việc'",
        videoID = "7WVeIhbCrdE",
        img = "ngheauto.png"
    },
    careerLevel = {
        title = "CẤP ĐỘ NGHỀ",
        name = "NGHỀ AUTO",
        progress = 0,
        target1 = 4800,
        level1 = 45,
        target2 = 7200,
        level2 = 85,
        target3 = 9600,
        level3 = 125,
        target4 = 12000,
        level4 = 150,
        img = "ngheauto.png"
    },
    start = {
        isPopup = true,
        isSidebar = true,
        msg = "Bạn đang làm",
    },
    isTeamwork = true,
    isCanBuy = false,
    rewards = GetTTVLRewards("ngheauto"),
    requirements = GetTTVLRequirements("ngheauto"),
    acceptJob = {
      eventname = 'f17_ngheauto:cl:DoJob',
      eventtype = 'client'
    },
    cancelJob = {
      eventname = 'f17_ngheauto:cl:CancelJob',
      eventtype = 'client'
    },
    upgradeJob = {
      eventname = 'f17_ngheauto:cl:NangCapNghe',
      eventtype = 'client'
    },
    button = {
      methodbtn = {
        solo = {
          buttonname = 'Chăn nuôi',
          eventname = 'f17_ngheauto:cl:DoJobChanNuoi',
          eventtype = 'client',
          eventfunction = {}
        },
        teamwork = {
          buttonname = 'Thu hoạch',
          eventname = 'f17_ngheauto:cl:DoJobThuHoach',
          eventtype = 'client',
          eventfunction = {}
        },
      },
      levelbtn = {},
      otherbtn = {}
    }
  },
  ['tomtit'] = {
    name = "TÔM TÍT",
    requiredLevel = 10,
    maxLevel = 3,
    hasLevel = true,
    toolImage = "tomtit",  -- Tên base, sẽ tự động thêm level
    home = {
      title = "TRANG CHỦ",
      description = "Hóa thân thành một ngư dân thực thụ, nơi bạn tự tay chinh phục những chú tôm tít cứng đầu và mang về nguồn thu nhập hấp dẫn tại Chợ Đầu Mối."..
      "<br><br><b>Hình thức:</b>"..
      "<br>- Cá nhân: Thư giãn, nhẹ nhàng"..
      "<br><br><b>Đặc điểm:</b>"..
      "<br>- Kinh nghiệm & giá vật phẩm nghề tăng giảm theo biến động việc làm và biến động chợ đầu mối",
      process = GetTTVLStats("tomtit"),
      img = "tomtit.png"
    },
    guide = {
        title = "HƯỚNG DẪN",
        description = "<b>Hướng dẫn:</b>"..
        "<br>1. Bắt đầu công việc và di chuyển xung quanh khu vực đánh bắt"..
        "<br>2. Ấn [E] để đào cát tìm tôm (Cần 'Dây câu tôm')"..
        "<br>3. Chinh phục minigame (Chia làm 3 giai đoạn kịch tính):"..
        "<br>🔍 <i>Tìm hang:</i> Sử dụng phím [Space] và Chuột để điều khiển dây câu len lỏi vào hang tôm."..
        "<br>⚡ <i>Kéo tôm khỏi hang:</i> Khi tôm cắn câu, Sử dụng phím [Space] tránh tôm trốn thoát."..
        "<br>🎁 <b>Đặc quyền Level 3:</b> Cơ hội xuất hiện rương kho báu, hoàn thành minigame đặc biệt để nhận thêm phần thưởng!"..
        "<br><br><b>Lưu ý:</b>"..
        "<br>- Mua 'Dây câu tôm' tại Tạp hoá."..
        "<br>- Nếu muốn dừng công việc, công dân về gặp NPC chọn 'Kết thúc công việc'.",
        videoID = "rrNg3IXr-S0",
        img = "tomtit.png"
    },
    careerLevel = {
      title = "CẤP ĐỘ NGHỀ",
      name = "TÔM TÍT",
      progress = 0,
      target1 = 700,
      level1 = 40,
      target2 = 1400,
      level2 = 75,
      img = "tomtit.png"
  },
    start = {
        isPopup = false,
        isSidebar = true,
        msg = "Bạn đang làm",
    },
    isTeamwork = false,
    isCanBuy = false,
    rewards = GetTTVLRewards("tomtit"),
    requirements = GetTTVLRequirements("tomtit"),
    acceptJob = {
      eventname = 'f17_tomtit:cl:DoJob',
      eventtype = 'client'
    },
    cancelJob = {
      eventname = 'f17_tomtit:cl:CancelJob',
      eventtype = 'client'
    },
    upgradeJob = {
      eventname = 'f17_tomtit:cl:NangCapNghe',
      eventtype = 'client'
    },
    button = {}
  },
  ['taxi'] = {
    name = "TAXI",
    requiredLevel = 20,
    maxLevel = 1,
    hasLevel = false,
   toolImage = "taxi1.png",  -- Ảnh công cụ nghề
    home = {
        title = "TRANG CHỦ",
        description = "Công dân có thể thực hiện chuyến chở NPC hoặc người chơi khác để kiếm thu nhập, trong quá trình chở NPC công dân có thể chờ người chơi khác sử dụng ping dịch vụ taxi và nhanh chóng nhận đơn để đón khách."..
        "<br><br><b>Hình thức:</b>"..
        "<br>- Cá nhân: Dễ dàng phù hợp với mọi công dân"..
        "<br><br><b>Đặc điểm:</b>"..
        "<br>- Tiền & kinh nghiệm tăng giảm theo biến động việc làm."..
        "<br>- Tiền & kinh nghiệm tăng theo level nghề."..
        "<br>- Có thể hoạt động chở người, có đồng hồ tính tiền theo miles."..
        "<br>- Có tiền Onl Duty theo thời gian.",
        process = GetTTVLStats("taxi"),
        img = "taxi.png"
    },
    guide = {
        title = "HƯỚNG DẪN",
        description = "<b>Hướng dẫn:</b>"..
        "<br>1. Bắt đầu công việc"..
        "<br>2. Chọn 'Thuê xe'"..
        "<br>3. Sử dụng [U] để đợi nổ đơn"..
        "<br>4. Di chuyến đến vị trí khách hàng được đánh dấu trên bản đồ"..
        "<br>5. Chở khách hàng đến vị trí chỉ định"..
        "<br>6. Lặp lại B2 để tiếp tục công việc"..
        "<br><br><b>Lưu ý:</b>"..
        "<br>- Nếu muốn dừng công việc, hoàn thành hết chuyến và về gặp NPC chọn 'Kết thúc công việc' (không được lặp lại B2)",
        videoID = "7WVeIhbCrdE",
        img = "taxi.png"
    },
    tasks = {
      title = "NHIỆM VỤ",
      task = {
        {
          nhiemvuname = 'CHỨNG CHỈ TAXI THƯỜNG',
          eventname = 'f17_taxi:cl:takeMissionTaxiThuong',
          eventtype = 'client',
          target = 40
        },
        {
          nhiemvuname = 'CHỨNG CHỈ TAXI TỰ DO',
          eventname = 'f17_taxi:cl:takeMissionTaxiTuDo',
          eventtype = 'client',
          target = 60
        },
      },
    },
    careerLevel = {},
    start = {
        isPopup = false,
        isSidebar = false,
        msg = "Bạn đang làm",
    },
    isTeamwork = false,
    isCanBuy = false,
    rewards = GetTTVLRewards("taxi"),
    requirements = GetTTVLRequirements("taxi"),
    acceptJob = {
      eventname = 'f17_taxi:cl:DoJob',
      eventtype = 'client'
    },
    cancelJob = {
      eventname = 'f17_taxi:cl:CancelJob',
      eventtype = 'client'
    },
    upgradeJob = {},
    button = {
      methodbtn = {},
      levelbtn = {},
      otherbtn = {
        {
          buttonname = 'Taxi tự do',
          eventname = 'f17_taxi:sv:takeTaxiTuDo',
          eventtype = 'server',
        },
        {
          buttonname = 'Thuê xe taxi',
          eventname = 'f17_taxi:cl:ThueXe',
          eventtype = 'client',
        },
        {
          buttonname = 'Trả xe taxi',
          eventname = 'f17_taxi:cl:TraXe',
          eventtype = 'client',
        }
      }
    }
  },
  ['lansanho'] = {
    name = "LẶN SAN HÔ",
    requiredLevel = 20,
    maxLevel = 1,
    hasLevel = false,
    toolImage = "lansanho1.png",  -- Ảnh công cụ nghề
    home = {
        title = "TRANG CHỦ",
        description = "Lặn san hô là nghề cốt lõi tại F17CITY, nơi cả newbie và oldbie đều tìm thấy cơ hội phát triển. Đây là nghề kiếm tiền IC và XP ổn định nhất, với công việc dễ dàng và không đòi hỏi quá nhiều kỹ năng."..
        "<br><br><b>Hình thức:</b>"..
        "<br>- Cá nhân: Cực kỳ dễ tiếp cận, thích hợp cho newbie lẫn oldbie"..
        "<br><br><b>Đặc điểm:</b>"..
        "<br>- Tiền & kinh nghiệm tăng giảm theo biến động việc làm."..
        "<br>- Có hệ thống cấp độ nghề riêng, level càng cao bạn càng kiếm được nhiều tiền và kinh nghiệm."..
        "<br>- Thay đổi vị trí làm việc mỗi cấp độ.",
        process = GetTTVLStats("lansanho"),
        img = "lansanho.png"
    },
    guide = {
        title = "HƯỚNG DẪN",
        description = "<b>Hướng dẫn:</b>"..
        "<br>1. Bắt đầu công việc"..
        "<br>2. Cá nhân/Tổ đội di chuyển đến bãi san hô và sử dụng [E] để làm việc"..
        "<br>3. Thu thập đủ số san hô yêu cầu"..
        "<br>4. Chọn 'Nhận lượt mới' sau khi nhận thưởng để bắt đầu lượt mới"..
        "<br><br><b>Lưu ý:</b>"..
        "<br>- Cooldown cá nhân/tổ đội 10 phút cho mỗi lượt mới.",
        videoID = "a9CaugqqSFo",
        img = "lansanho.png"
    },
    careerLevel = {},
    start = {
        isPopup = true,
        isSidebar = false,
        msg = "Bạn đang làm",
    },
    isTeamwork = true,
    isCanBuy = false,
    rewards = GetTTVLRewards("lansanho"),
    requirements = GetTTVLRequirements("lansanho"),
    acceptJob = {
      eventname = 'f17_lansanho:cl:DoJob',
      eventtype = 'client'
    },
    cancelJob = {
      eventname = 'f17_lansanho:cl:CancelJob',
      eventtype = 'client'
    },
    button = {
      methodbtn = {
        solo = {
          buttonname = 'Cá nhân',
          eventname = 'f17_lansanho:cl:DoJobCaNhan',
          eventtype = 'client',
          eventfunction = { 
            canhan = true 
          }
        },
      teamwork = {
          buttonname = 'Tổ đội',
          eventname = 'f17_lansanho:cl:DoJobToDoi',
          eventtype = 'client',
          eventfunction = { 
            todoi = true 
          }
        },
      },
      levelbtn = {},
      otherbtn = {
        {
          buttonname = 'Nhận thưởng',
          eventname = 'f17_lansanho:cl:rewardSanHo',
          eventtype = 'client',
        },
        {
          buttonname = 'Nhận lượt mới',
          eventname = 'f17_lansanho:cl:takeNewRoute',
          eventtype = 'client',
        }
      }
    }
  },
  ['vanchuyen'] = {
    name = "VẬN CHUYỂN",
    requiredLevel = 20,
    maxLevel = 1,
    hasLevel = false,
    toolImage = "vanchuyen1.png",  -- Ảnh công cụ nghề
    home = {
      title = "TRANG CHỦ",
      description = "Vận chuyển là nghề Co-Op thú vị của thành phố, mang đến trải nghiệm làm việc nhóm vui nhộn. Các công dân có thể tạo đội để cùng vận chuyển hàng hóa đến các địa điểm trong thành phố."..
      "<br><br><b>Hình thức:</b>"..
      "<br>- Co-Op (4 người): Làm việc nhóm với tương tác cao, phối hợp để hoàn thành nhiệm vụ"..
      "<br>- Mỗi thành viên một vai trò riêng, tạo nên một đội ngũ vận chuyển chuyên nghiệp"..
      "<br><br><b>Đặc điểm:</b>"..
      "<br>- Tiền & kinh nghiệm tăng giảm theo biến động việc làm."..
      "<br>- Tốc độ làm việc nhanh khi đồng đội phối hợp ăn ý"..
      "<br>- Nhiều thử thách thú vị đang chờ đón bạn và đồng đội.",
      process = GetTTVLStats("vanchuyen"),
      img = "vanchuyen.png"
    },
    guide = {
      title = "HƯỚNG DẪN",
      description = "<b>Hướng dẫn:</b>"..
      "<br>1. Bắt đầu công việc (Yêu cầu tổ đội 4 người)"..
      "<br>2. Điều khiển xe nâng chuyên dụng, chất hàng vào kho (Dùng SHIFT & CTRL)"..
      "<br>3. Sau khi chất hết thùng hàng, tương tác NPC chọn 'Nhận xe tải'"..
      "<br>4. Lái xe tải đến vị trí chỉ định để giao hàng"..
      "<br>5. Quay lại tương tác NPC chọn 'Nhận thưởng'"..
      "<br><br><b>Lưu ý:</b>"..
      "<br>- Chọn 'Nhận xe tải' khi đã chất đủ thùng hàng"..
      "<br>- Chọn 'Nhận thưởng' sau khi hoàn thành chuyến.",
      videoID = "7WVeIhbCrdE",
      img = "vanchuyen.png"
    },
    careerLevel = {},
    start = {
        isPopup = false,
        isSidebar = true,
        msg = "Bạn đang làm",
    },
    isTeamwork = false,
    isCanBuy = false,
    rewards = GetTTVLRewards("vanchuyen"),
    requirements = GetTTVLRequirements("vanchuyen"),
    acceptJob = {
      eventname = 'f17_vanchuyen:cl:DoJob',
      eventtype = 'client'
    },
    cancelJob = {
      eventname = 'f17_vanchuyen:cl:CancelJob',
      eventtype = 'client'
    },
    upgradeJob = {},
    button = {
      otherbtn = {
        {
          buttonname = 'Nhận xe tải',
          eventname = 'f17_vanchuyen:cl:takeXeTai',
          eventtype = 'client'
        },
        {
          buttonname = 'Nhận thưởng',
          eventname = 'f17_vanchuyen:cl:rewardvanchuyen',
          eventtype = 'client'
        },
        {
          buttonname = 'Nhận lượt mới',
          eventname = 'f17_vanchuyen:cl:takeNewRoute',
          eventtype = 'client'
        }
      }
    }
  },
  ['sanban'] = {
    name = "SĂN BẮN",
    requiredLevel = 25,
    maxLevel = 2,
    hasLevel = true,
    toolImage = "sanban",  -- Tên base, sẽ tự động thêm level
    home = {
        title = "TRANG CHỦ",
        description = "Bạn sẽ nhập vai trở thành thợ săn tài ba, nghề Săn thú sẽ mang lại số nguyên liệu nhiều hơn so với các nghề khác, cùng với tiền IC và XP nhân vật."..
        "<br><br><b>Hình thức:</b>"..
        "<br>- Cá nhân: Độ khó vừa phải, cần sự kiên trì"..
        "<br><br><b>Đặc điểm:</b>"..
        "<br>- Tiền & kinh nghiệm tăng giảm theo biến động việc làm."..
        "<br>- Tiền & kinh nghiệm tăng theo level nghề.",
        "<br>- Người chơi được hoạt động cùng thú cưng để truy tìm dấu vết."..
        "<br>- Có phần thưởng bonus.",
        process = GetTTVLStats("sanban"),
        img = "sanban.png"
    },
    guide = {
      title = "HƯỚNG DẪN",
      description = "<b>Hướng dẫn:</b>"..
      "<br>1. Bắt đầu công việc"..
      "<br>2. Đi khảo sát khu vực để tìm dấu vết thú săn (có thể gọi thú cưng ra hỗ trợ tìm dấu vết)"..
      "<br>3. Ấn [E] để tìm kiếm khi đã thấy dấu vết (Sau đó lặp lại đến khi phát hiện thú săn)"..
      "<br>4. Giết thú săn sau đó dùng ALT + Chuột để lấy thịt"..
      "<br><br><b>Lưu ý:</b>"..
      "<br>- Nên có thú cưng đễ dễ tìm dấu vết thú săn."..
      "<br>- Không đi ra khỏi Zone Săn thú trong quá trình làm việc."..
      "<br>- Cooldown cá nhân 6 phút cho mỗi lượt mới.",
      videoID = "IxytOLJEWYU",
      img = "sanban.png"
    },
    careerLevel = {
        title = "CẤP ĐỘ NGHỀ",
        name = "SĂN THÚ",
        progress = 0,
        target1 = 500,
        level1 = 25,
        img = "sanban.png"
    },
    start = {
        isPopup = true,
        isSidebar = false,
        msg = "Bạn đang làm",
    },
    isTeamwork = false,
    isCanBuy = true,
    buyMsg = "Bạn có thể nhận vị trí săn thú theo cấp độ nghề.",
    rewards = GetTTVLRewards("sanban"),
    requirements = GetTTVLRequirements("sanban"),
    acceptJob = {
      eventname = 'f17_sanban:cl:DoJob',
      eventtype = 'client'
    },
    cancelJob = {
      eventname = 'f17_sanban:cl:CancelJob',
      eventtype = 'client'
    },
    upgradeJob = {
      eventname = 'f17_sanban:cl:NangCapNghe',
      eventtype = 'client'
    },
    button = {
      methodbtn = {},
      levelbtn = {
        {
          buttonname = 'Cấp độ 1',
          eventname = 'f17_sanban:cl:DoJob',
          eventtype = 'client',
          eventfunction = { level = 1 }
        },
        {
          buttonname = 'Cấp độ 2',
          eventname = 'f17_sanban:cl:DoJob',
          eventtype = 'client',
          eventfunction = { level = 2 }
        }
      },
      otherbtn = {
        {
          buttonname = 'Nhận lượt mới',
          eventname = 'f17_sanban:cl:takeNewRoute',
          eventtype = 'client',
        }
      }
    }
  },
  ['lankhobau'] = {
    name = "LẶN KHO BÁU",
    requiredLevel = 30,
    maxLevel = 3,
    hasLevel = true,
    toolImage = "lankhobau",  -- Tên base, sẽ tự động thêm level
    home = {
        title = "TRANG CHỦ",
        description = "Bạn sẽ nhập vai trở thành thợ lặn truy tìm kho báu dưới đáy biển, nghề mang lại cho bạn sự rùng rợn khi ở giữa đại dương rộng lớn và mang lại sự phấn khích, giàu có khi tìm thấy kho báu."..
        "<br><br><b>Hình thức:</b>"..
        "<br>- Cá nhân: Bạn sẽ cần bỏ tiền để mua vị trí kho báu, sau đó hoàn thành thật tốt minigame thu hoạch kho báu để nhận thưởng."..
        "<br><br><b>Đặc điểm:</b>"..
        "<br>- Tiền & kinh nghiệm tăng giảm theo biến động việc làm."..
        "<br>- Tiền & kinh nghiệm tăng theo level nghề."..
        "<br>- Tiền kiếm được tỉ lệ thuận với kĩ năng người chơi.",
        "<br>- Số lần <b>Perfect</b> liên tục nhiều sẽ nhận được nhiều thưởng hơn, miss - bad thì ít hơn.",
        process = GetTTVLStats("lankhobau"),
        img = "lankhobau.png"
    },
    guide = {
        title = "HƯỚNG DẪN",
        description = "<b>Hướng dẫn:</b>"..
        "<br>1. Bắt đầu công việc"..
        "<br>2. Chọn vị trí làm việc dựa theo cấp độ nghề của bạn"..
        "<br>3. Trang bị kỹ đồ nghề và thuê thuyền di chuyển ra khu vực lặn kho báu"..
        "<br>4. Tiến hành lặn và thu thập kho báu"..
        "<br><br><b>Lưu ý:</b>"..
        "<br>- Cooldown cá nhân 10 phút cho mỗi lượt mới.",
        videoID = "7WVeIhbCrdE",
        img = "lankhobau.png"
    },
    careerLevel = {
        title = "CẤP ĐỘ NGHỀ",
        name = "LẶN KHO BÁU",
        progress = 0,
        target1 = 210,
        level1 = 65,
        target2 = 420,
        level2 = 100,
        img = "lankhobau.png"
    },
    start = {
        isPopup = true,
        isSidebar = false,
        msg = "Bạn đang làm",
    },
    isTeamwork = false,
    isCanBuy = true,
    buyMsg = "Dựa theo cấp độ nghề, bạn có thể nhận được các vị trí kho báu từ dễ - trung bình - khó."..
    "<br>Mỗi vị trí kho báu sẽ có độ khó tăng dần kèm theo tiền thưởng xứng đáng với thành quả.",
    rewards = GetTTVLRewards("lankhobau"),
    requirements = GetTTVLRequirements("lankhobau"),
    acceptJob = {
      eventname = 'f17_lankhobau:cl:DoJob',
      eventtype = 'client'
    },
    cancelJob = {
      eventname = 'f17_lankhobau:cl:CancelJob',
      eventtype = 'client'
    },
    upgradeJob = {
      eventname = 'f17_lankhobau:cl:NangCapNghe',
      eventtype = 'client'
    },
    button = {
      methodbtn = {},
      levelbtn = {
        {
          buttonname = 'Dễ ($5000)',
          eventname = 'f17_lankhobau:cl:DoJob',
          eventtype = 'client',
          eventfunction = { level = 1, price = 5000 }
        },
        {
          buttonname = 'Trung bình ($10000)',
          eventname = 'f17_lankhobau:cl:DoJob',
          eventtype = 'client',
          eventfunction = { level = 2, price = 10000 }
        },
        {
          buttonname = 'Khó ($15000)',
          eventname = 'f17_lankhobau:cl:DoJob',
          eventtype = 'client',
          eventfunction = { level = 3, price = 15000 }
        }
      },
      otherbtn = {
        {
          buttonname = 'Nhận lượt mới',
          eventname = 'f17_lankhobau:cl:takeNewRoute',
          eventtype = 'client',
        }
      }
    }
  }
}