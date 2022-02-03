function main() {
    return {
        show: false,
        tab: '0',
        wallet: 0,
        balance: 0,
        deposit: 0,
        withdraw: 0,
        close() {
            $.post('http://bank/escape', JSON.stringify({}))
            this.show = false
            this.tab = '0'
            this.wallet = 0
            this.balance = 0
            this.deposit = 0
            this.withdraw = 0
        },
        dp() {
            $.post('http://bank/deposit', JSON.stringify({ amount: this.deposit })).then(data => {
                this.wallet = data.wallet
                this.balance = data.bank
                this.deposit = 0
            });
        },
        wh() {
            $.post('http://bank/withdraw', JSON.stringify({ amount: this.withdraw })).then(data => {
                this.wallet = data.wallet
                this.balance = data.bank
                this.withdraw = 0
            });
        },
        listen() {
            window.addEventListener('message', (event) => {
                let data = event.data
                this.show = data.show
                this.balance = Intl.NumberFormat().format(data.bank)
                this.wallet = Intl.NumberFormat().format(data.wallet)
            })
        }
    }
}