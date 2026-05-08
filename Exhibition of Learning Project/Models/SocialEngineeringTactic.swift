//
//  SocialEngineeringTactic.swift
//  Exhibition of Learning Project
//
//  Created by Dittrich, Jan - Student on 5/7/26.
//


import Foundation

// MARK: - Social Engineering Tactic
enum SocialEngineeringTactic: String, CaseIterable {
    case urgency = "Urgency / Scarcity"
    case impersonation = "Impersonation"
    case curiosity = "Curiosity Baiting"
    case authority = "Authority Exploitation"
    case fear = "Fear & Intimidation"
    case reward = "Reward / Greed"
    case pretexting = "Pretexting"
    case none = "None"

    var icon: String {
        switch self {
        case .urgency: return "clock.badge.exclamationmark"
        case .impersonation: return "person.fill.questionmark"
        case .curiosity: return "questionmark.circle"
        case .authority: return "shield.lefthalf.filled"
        case .fear: return "exclamationmark.triangle"
        case .reward: return "gift"
        case .pretexting: return "theatermasks"
        case .none: return "checkmark.seal"
        }
    }

    var color: String { // system color name
        switch self {
        case .urgency: return "orange"
        case .impersonation: return "purple"
        case .curiosity: return "blue"
        case .authority: return "indigo"
        case .fear: return "red"
        case .reward: return "yellow"
        case .pretexting: return "teal"
        case .none: return "green"
        }
    }
}

// MARK: - Red Flag
struct RedFlag: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

// MARK: - Email Model
struct PhishingEmail: Identifiable {
    let id = UUID()
    let sender: String
    let senderEmail: String
    let senderInitials: String
    let senderAvatarColor: String
    let subject: String
    let preview: String
    let body: String
    let date: String
    let isPhishing: Bool
    let tactic: SocialEngineeringTactic
    let tacticExplanation: String
    let redFlags: [RedFlag]
    let difficulty: Difficulty

    enum Difficulty: String {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"

        var color: String {
            switch self {
            case .easy: return "green"
            case .medium: return "orange"
            case .hard: return "red"
            }
        }
    }
}

// MARK: - Sample Email Data
let sampleEmails: [PhishingEmail] = [

    // ── PHISHING ──────────────────────────────────────────────────────────────

    PhishingEmail(
        sender: "Apple Support",
        senderEmail: "support@apple-secure-id.com",
        senderInitials: "AS",
        senderAvatarColor: "gray",
        subject: "⚠️ Your Apple ID has been suspended",
        preview: "Immediate action required. Your account has been flagged for suspicious activity…",
        body: """
Dear Valued Customer,

We have detected **suspicious activity** on your Apple ID account. To prevent unauthorized access, your account has been **temporarily suspended**.

**You must verify your identity within 24 hours** or your account will be permanently deleted and all purchases will be lost.

[Verify Now → appleid-secure-login.com/verify]

If you do not verify immediately, you will lose access to:
• iCloud storage and backups
• App Store purchases
• Apple Pay

This is your **FINAL notice**.

— Apple Security Team
""",
        date: "09:42",
        isPhishing: true,
        tactic: .urgency,
        tacticExplanation: "**Urgency / Scarcity** is one of the most common phishing tactics. Attackers create an artificial deadline or threat — 'act within 24 hours or lose everything' — to overwhelm your rational thinking. When under perceived time pressure, people skip critical checks like inspecting the sender's email address. Real companies like Apple *never* demand immediate action via email to avoid account deletion.",
        redFlags: [
            RedFlag(title: "Suspicious Sender Domain", description: "The real Apple sends mail from @apple.com. This email comes from 'apple-secure-id.com' — a lookalike domain registered by attackers."),
            RedFlag(title: "Artificial 24-Hour Deadline", description: "Legitimate services don't threaten permanent deletion within 24 hours over a single email. This is designed to prevent you from thinking clearly."),
            RedFlag(title: "Misleading Link", description: "The link points to 'appleid-secure-login.com', not apple.com. Always hover over links to check the real destination before clicking."),
            RedFlag(title: "Generic Greeting", description: "'Dear Valued Customer' — Apple knows your name. Phishing emails often use generic greetings because they're sent in bulk to thousands of victims."),
            RedFlag(title: "Emotional Threat of Loss", description: "Threatening to delete purchases and backups is designed to trigger an emotional panic response that bypasses rational thinking.")
        ],
        difficulty: .easy
    ),

    PhishingEmail(
        sender: "IT Department",
        senderEmail: "it-helpdesk@company-portal-svc.net",
        senderInitials: "IT",
        senderAvatarColor: "blue",
        subject: "Action Required: Reset your company password",
        preview: "Your password expires today. Click the link below to reset it and avoid being locked out…",
        body: """
Hello,

Our records show your **company password expires today**. To avoid being locked out of your workstation and email, please reset it immediately using the secure portal below.

[Reset Password → company-portal-svc.net/reset]

**Important:** This link expires in 2 hours. If you are locked out, contact us at helpdesk@company-portal-svc.net.

If you have already reset your password, please disregard this message.

IT Helpdesk
""",
        date: "Yesterday",
        isPhishing: true,
        tactic: .impersonation,
        tacticExplanation: "**Impersonation** involves disguising oneself as a trusted entity — in this case, your company's IT department. Combined with **pretexting** (a fabricated scenario about password expiry), the attacker creates a believable context that feels routine. Most employees get legitimate IT emails, making this particularly effective. The key tell is the external, non-company domain being used.",
        redFlags: [
            RedFlag(title: "External Domain Impersonating IT", description: "A real company IT department sends emails from the company's own domain (e.g., @yourcompany.com), not a third-party domain like 'company-portal-svc.net'."),
            RedFlag(title: "Urgency via Expiry", description: "The 2-hour expiry window is another manufactured urgency. Real password reset policies are communicated in advance through official channels."),
            RedFlag(title: "Generic 'Company' Reference", description: "The email never mentions the actual company name. Attackers send these broadly hoping to hit employees at various organizations."),
            RedFlag(title: "Reset Link Goes Off-Domain", description: "Legitimate IT password resets redirect to your company's own identity provider (e.g., Okta, Microsoft), not an unknown external site.")
        ],
        difficulty: .medium
    ),

    PhishingEmail(
        sender: "DHL Express",
        senderEmail: "noreply@dhl-tracking-update.info",
        senderInitials: "DH",
        senderAvatarColor: "yellow",
        subject: "Your package could not be delivered — reschedule now",
        preview: "We attempted delivery of your parcel today. A small fee of $2.99 is required to reschedule…",
        body: """
Dear Customer,

We attempted to deliver your parcel **(Tracking #DHL-7742938)** today but were unable to complete delivery.

To reschedule your delivery, a small **customs/redelivery fee of $2.99** must be paid within 48 hours, or your parcel will be returned to sender.

[Pay $2.99 & Reschedule → dhl-tracking-update.info/pay]

Please have your card details ready.

Thank you,
DHL Customer Service
""",
        date: "Mon",
        isPhishing: true,
        tactic: .reward,
        tacticExplanation: "**Smishing/Parcel Scam** uses the expectation of receiving a package — almost universal in the era of online shopping — as a pretext. The small fee ($2.99) is psychologically clever: the amount feels too trivial to be a scam, lowering your defenses. But the real goal is harvesting your full credit card details. Once entered, attackers have everything needed for large fraudulent charges.",
        redFlags: [
            RedFlag(title: "Fake DHL Domain", description: "DHL sends tracking emails from @dhl.com. 'dhl-tracking-update.info' is a completely separate domain designed to look official."),
            RedFlag(title: "Small Fee as Disarming Tactic", description: "A $2.99 fee seems harmless, but to pay it you enter full card details — which are then stolen for much larger fraudulent transactions."),
            RedFlag(title: "Generic Tracking Number", description: "Real DHL tracking numbers follow a specific format and are linked to actual shipments you can verify on dhl.com directly."),
            RedFlag(title: "No Sender Personalization", description: "DHL knows your name and address. 'Dear Customer' signals a mass phishing campaign, not a real delivery notification.")
        ],
        difficulty: .medium
    ),

    PhishingEmail(
        sender: "Microsoft 365",
        senderEmail: "microsoftsupport@m1cr0soft-accounts.com",
        senderInitials: "MS",
        senderAvatarColor: "indigo",
        subject: "Unusual sign-in activity detected on your Microsoft account",
        preview: "We noticed a sign-in from Kyiv, Ukraine on May 6, 2026 at 3:14 AM. If this wasn't you…",
        body: """
Microsoft Account Security Alert

We noticed a sign-in to your Microsoft account from an unusual location:

**Location:** Kyiv, Ukraine
**Date:** May 6, 2026, 3:14 AM
**Device:** Windows PC (Chrome)

**If this wasn't you**, please secure your account immediately by changing your password and reviewing your recent activity.

[Secure My Account → m1cr0soft-accounts.com/secure]

If you initiated this sign-in, you can safely ignore this message.

Microsoft Account Team
""",
        date: "Today",
        isPhishing: true,
        tactic: .fear,
        tacticExplanation: "**Fear & Intimidation** exploits the emotional response triggered by believing someone has broken into your account. By providing seemingly specific details (a real-looking location, time, and device), attackers make the scenario feel credible and urgent. The fear of losing control of your account pushes victims to click immediately without scrutinizing the sender. This is sometimes called 'account compromise phishing.'",
        redFlags: [
            RedFlag(title: "Misspelled Domain with Numbers", description: "'m1cr0soft' replaces letters with numbers — a classic typosquatting technique. Always look carefully at the actual email address, not just the display name."),
            RedFlag(title: "Specific Details Create False Credibility", description: "Providing a country, exact timestamp, and device type makes the email feel authentic. These details are fabricated and can be generated automatically for thousands of targets."),
            RedFlag(title: "Fear-Driven Call to Action", description: "The 'secure my account' link leads to a credential harvesting page. Real Microsoft security alerts link to account.microsoft.com — a domain you can type directly into your browser."),
            RedFlag(title: "No Account Username Shown", description: "Real Microsoft alerts reference your full email address or partial username. Generic security alerts that don't specify your account are suspicious.")
        ],
        difficulty: .hard
    ),

    PhishingEmail(
        sender: "Sarah Chen",
        senderEmail: "s.chen.cfo@acme-finances.co",
        senderInitials: "SC",
        senderAvatarColor: "purple",
        subject: "Confidential — Wire transfer needed today",
        preview: "Hi, I need you to process an urgent wire transfer. I'm in a meeting and can't take calls right now…",
        body: """
Hi,

I need your help with something urgent and confidential. I'm currently in a board meeting and cannot take calls.

We're closing an acquisition deal and I need a **wire transfer of $47,500** processed to the vendor before 5 PM today. This is time-sensitive — the deal depends on it.

Please transfer to:
**Bank:** First National Bank
**Account:** 8821-004-7734
**Routing:** 021000021

I'll explain everything once I'm out of the meeting. **Please don't discuss this with anyone else** — it's under NDA.

Thanks,
Sarah Chen
CFO, ACME Corp
""",
        date: "Today",
        isPhishing: true,
        tactic: .authority,
        tacticExplanation: "**Business Email Compromise (BEC)** / CEO Fraud is the most financially damaging form of phishing — costing businesses billions annually. The attacker impersonates a senior executive (CFO, CEO) using a lookalike email domain. Key psychological levers: **authority** (you don't question the CFO), **confidentiality** (prevents you from verifying with colleagues), and **urgency** (the deal closes today). Always verify large wire transfers via a separate, known phone number.",
        redFlags: [
            RedFlag(title: "Lookalike Domain", description: "'acme-finances.co' looks plausible but is not the real company domain. Attackers register similar domains specifically for BEC attacks."),
            RedFlag(title: "Secrecy Demand is a Red Flag", description: "'Don't discuss with anyone' is designed to isolate you and prevent verification. Legitimate business transactions have internal approval workflows."),
            RedFlag(title: "Unavailability Prevents Verification", description: "Claiming to be in a meeting and unable to take calls is a scripted excuse to prevent you from calling the real executive to confirm."),
            RedFlag(title: "Urgency + Large Financial Request", description: "Any same-day wire transfer request for a significant amount — especially from an executive — should trigger additional verification regardless of how legitimate it seems."),
            RedFlag(title: "No Standard Invoice or PO", description: "Legitimate vendor payments follow established processes with invoices and purchase orders. Real CFOs don't bypass these controls via personal email.")
        ],
        difficulty: .hard
    ),

    // ── LEGITIMATE ────────────────────────────────────────────────────────────

    PhishingEmail(
        sender: "GitHub",
        senderEmail: "noreply@github.com",
        senderInitials: "GH",
        senderAvatarColor: "black",
        subject: "[GitHub] A new SSH key was added to your account",
        preview: "A new SSH key was recently added to your GitHub account. If you added this key, no action is needed…",
        body: """
Hi there,

A **new SSH key** was recently added to your GitHub account (**@yourusername**).

**Key fingerprint:** SHA256:x7kJm9Rq4tVn...

If you added this key — for example, when setting up a new computer — **you don't need to do anything**.

If you did **not** add this key, please remove it from your account settings immediately:
[Review SSH keys → github.com/settings/keys]

Stay secure,
The GitHub Team

---
You're receiving this because your email address is associated with a GitHub account. To stop receiving security notifications, visit your notification preferences at github.com/settings/notifications.
""",
        date: "11:20",
        isPhishing: false,
        tactic: .none,
        tacticExplanation: "This is a **legitimate security notification** from GitHub. Notice how it differs from phishing emails: the sender domain is the real @github.com, it references your actual username, the link goes directly to github.com (not a lookalike), there is no urgency or threat, and it even explains how to unsubscribe. Legitimate security emails inform you — they don't demand immediate action or ask you to enter credentials.",
        redFlags: [],
        difficulty: .easy
    ),

    PhishingEmail(
        sender: "Spotify",
        senderEmail: "no-reply@spotify.com",
        senderInitials: "SP",
        senderAvatarColor: "green",
        subject: "Your Spotify receipt – May 2026",
        preview: "Thanks for your payment. Your Spotify Premium subscription has been renewed for another month…",
        body: """
Hi there,

Thanks for your payment! Here's your receipt for **Spotify Premium**.

**Date:** May 1, 2026
**Plan:** Premium Individual
**Amount:** $11.99
**Payment method:** Visa ending in 4242

Your subscription is active and you're all set to keep listening without limits.

[View your account → spotify.com/account]
[Manage subscription → spotify.com/account/subscription]

If you have questions about this charge, visit our support page at support.spotify.com.

Thanks for being a Spotify listener,
The Spotify Team

---
This receipt was sent to your registered email address. Spotify AB, Regeringsgatan 19, SE-111 53 Stockholm, Sweden.
""",
        date: "Yesterday",
        isPhishing: false,
        tactic: .none,
        tacticExplanation: "This is a **genuine subscription receipt** from Spotify. Signs of legitimacy: real @spotify.com sender domain, all links go to spotify.com or support.spotify.com subdomains, it references specific payment details (last 4 digits) you recognize, there is no urgency or call to enter credentials, and it includes a real company address. Legitimate receipts are informational — they confirm what already happened, rather than demanding you take action.",
        redFlags: [],
        difficulty: .easy
    ),

    PhishingEmail(
        sender: "Notion",
        senderEmail: "no-reply@mail.notion.so",
        senderInitials: "NO",
        senderAvatarColor: "gray",
        subject: "Lena Schmidt shared a document with you",
        preview: "Lena Schmidt has invited you to collaborate on 'Q2 Product Roadmap'. Click to open in Notion…",
        body: """
**Lena Schmidt** has shared a Notion page with you.

---

**Q2 Product Roadmap**
*Shared by lena.schmidt@yourcompany.com*

Lena left a comment: *"Added the new feature prioritization matrix — let me know what you think!"*

[Open in Notion → notion.so/your-workspace/q2-roadmap-...]

---

You're receiving this because you have a Notion account associated with this email address.
Manage notification settings at notion.so/settings/notifications

Notion, 2300 Harrison St, San Francisco, CA 94110
""",
        date: "Mon",
        isPhishing: false,
        tactic: .none,
        tacticExplanation: "This is a **legitimate Notion collaboration invite**. The sender uses Notion's real email infrastructure (@mail.notion.so — a legitimate subdomain). The sharing link goes to notion.so. It identifies the specific colleague by name and email address, and references a realistic document title. Legitimate sharing notifications identify real senders you may know. The lack of urgency, threats, or credential requests are strong signals of authenticity.",
        redFlags: [],
        difficulty: .medium
    )
]
