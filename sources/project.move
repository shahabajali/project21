module MyModule::EducationalIncentives {

    use aptos_framework::coin;
    use aptos_framework::signer;
    use aptos_framework::aptos_coin::{AptosCoin};

    struct Reward has store, key {
        student: address,
        tokens_earned: u64,
        is_claimed: bool,
    }

    // Function to reward a student for an achievement
    public fun reward_student(account: &signer,student: address, tokens_earned: u64) {
        let reward = Reward {
            student,
            tokens_earned,
            is_claimed: false,
        };
        move_to(account, reward);
    }

    // Function for students to claim their earned tokens
    public fun claim_tokens(student: &signer) acquires Reward {
        let reward = borrow_global_mut<Reward>(signer::address_of(student));

        // Ensure the reward has not been claimed yet
        assert!(!reward.is_claimed, 1);

        // Transfer the earned tokens to the student
        coin::transfer<AptosCoin>(student, signer::address_of(student), reward.tokens_earned);

        // Mark reward as claimed
        reward.is_claimed = true;
    }
}
