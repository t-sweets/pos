import Vue from 'vue'

Vue.mixin({
    methods: {
        dateFormat: (date, format) => {
            if (!format) {
                format = 'YYYY/MM/DD(E) hh:mm:ss'
            }
            const weekday = ["日", "月", "火", "水", "木", "金", "土"];
            format = format.replace(/YYYY/g, date.getFullYear());
            format = format.replace(/MM/g, ('0' + (date.getMonth() + 1)).slice(-2));
            format = format.replace(/DD/g, ('0' + date.getDate()).slice(-2));
            format = format.replace(/E/g, weekday[date.getDay()]);
            format = format.replace(/hh/g, ('0' + date.getHours()).slice(-2));
            format = format.replace(/mm/g, ('0' + date.getMinutes()).slice(-2));
            format = format.replace(/ss/g, ('0' + date.getSeconds()).slice(-2));
            return format;
        },
        jancodeValidate: (jancode) => {
            if (!jancode || jancode == "") return false;

            let nums = jancode.split('');
            const checkdigit = nums[nums.length-1];            
            nums = nums.filter((num, index) => {
                return index != nums.length-1
            })

            let even = 0;
            let odd = 0;
            try {
                nums.forEach((num, index) => {
                    if (index % 2 === 0) odd += parseInt(num);
                    else even += parseInt(num);
                });
                const digit = 10 - parseInt((even * 3 + odd + "").slice(-1));
                return (digit < 10 ? digit : 0) == checkdigit
            } catch (e) {
                return false;
            }
        }
    }
});
