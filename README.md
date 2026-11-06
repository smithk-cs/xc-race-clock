# XC Race Clock

A shared race clock for cross country coaches.

- One coach presses **Start** at the gun, and every coach's phone runs the same clock. The clocks are synced to the server's time.
- Coaches at each spot on the course tap the **jersey color** of each runner who passes.
- **Team scores** update live at every spot, using standard cross country scoring.
- The **Crew** tab shows which coaches are connected right now, where they're standing, and whether any taps are waiting to send.
- The **OBS overlay** puts the race clock and team scores on your livestream.
- **Family link:** a read-only view of the clock and scores.

It's free to run. The page is hosted on GitHub Pages and the data is stored in Supabase's free plan.

## One-time setup (about 15 minutes)

### 1. Supabase (stores the race data)
1. Go to supabase.com → **New project**. Name it `xc-race-clock`, pick a region near you, and save the database password somewhere.
2. When it's ready, open **SQL Editor → New query**. Paste in everything from `setup.sql` and click **Run**. You should see "Success".
3. In **Project Settings**, copy two values:
   - **Data API** page: the **Project URL**
   - **API Keys** page: the **Publishable key**, which starts with `sb_publishable_`. Don't use a secret key.

### 2. Add your keys
Open `config.js` and paste the two values between the quotes:
```js
window.XC_SUPABASE = {
  url: "https://YOURPROJECT.supabase.co",
  anonKey: "sb_publishable_..."
};
```
The publishable key is designed to be public, so it's fine for it to sit in a public page.

### 3. Turn on GitHub Pages
In this repository on GitHub, open **Settings → Pages**. Under "Build and deployment", choose **Deploy from a branch**, then select **main** and **/ (root)**, and click **Save**.
After a minute your page will be at `https://YOUR-GITHUB-NAME.github.io/xc-race-clock/`.

## Race day
1. **Head coach:** open the page and tap **Create a meet**, then go to **Setup**:
   - add each school's name and jersey color
   - add the coach spots (for example 1 Mile, 2 Mile, Finish)
   - tap **Create race**
2. In **Setup → Share this meet**, send the **coach link**, or show its QR code. Send the **family link** to parents if you want.
3. **Each coach** opens the link, types their name and picks their spot.
4. **Starter:** go to **Start** and press **START** at the gun.
5. Coaches tap jersey colors as runners pass. Check **Crew** to make sure every spot has a coach online.
6. For the next race, go to **Setup → New race, same teams**.

### Livestream overlay (OBS)
In OBS: **Sources → + → Browser**. Paste the **OBS overlay** link from Setup and set the size to 1920 × 1080. The background is already see-through, so the clock and scores sit on top of your camera.

## Good to know
- **Clock sync.** The clock is synced to Supabase's server time, so phones agree to within a fraction of a second even if a phone's own clock is off.
- **Weak signal.** Taps are saved on the phone first and sent when signal returns. The badge at the top shows **Live**, **Sending…** or **No signal: taps saved on phone**.
- **Who can edit.** The meet code works like a password for that race. Anyone with the coach link can tap times and change the race, so share it only with coaches. The family link hides the coach buttons, but it isn't a password.
- **Supabase pauses unused free projects after about a week with no activity.** If the page says it can't reach the race, open your Supabase dashboard and click **Restore project**. Opening the page once midweek keeps the project awake.
- Race data (school names, jersey colors and times) can be read by anyone who has the page and its key. Don't put athlete names or other private information in it.
