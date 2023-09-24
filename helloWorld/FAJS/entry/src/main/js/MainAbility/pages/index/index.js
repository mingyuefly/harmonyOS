// @ts-nocheck
import router from '@ohos.router';

export default {
    data: {
        title: ""
    },
    onInit() {
        this.title = this.$t('strings.world');
    },
    onClick () {
        router.push({
            url: "pages/Second/Second"
        })
    }
}




