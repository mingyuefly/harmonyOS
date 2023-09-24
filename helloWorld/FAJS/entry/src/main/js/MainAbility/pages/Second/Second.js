import router from '@ohos.router'
export default {
    data: {
        title: ""
    },
    onInit() {
        this.title = "Hi there";
    },
    onClick() {
        router.back()
    }
}
