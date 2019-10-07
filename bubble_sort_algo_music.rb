unsorted_arr = [81, 79, 69, 59, 55, 71, 83, 52, 64, 74, 76, 62, 57, 67, 86, 88]

# Bubble sort algorithm
def bubble_sort array
  arr = array.dup # create a copy of original array for sorting
  swapped = false
  r = arr.length - 2
  
  # DATA tracking variables
  array_states = []
  total_swaps = 0
  swaps_per_iter = []
  num_iters = 0
  time_of_exec = 0
  
  use_bpm 80
  
  # Play the unsorted array once
  # Each note is played at an interval of 0.25s
  arr.each { |n| play n; sleep 0.25 }
  
  start_time = Time.now # Start calculating time of execution
  
  while true do
      swaps = 0
      num_iters += 1
      
      in_thread do
        # Gives a bass frequency (take lowest value of the array)
        use_synth :dsaw
        play 52, amp: 0.5, attack: 2, sustain: 6, decay: 2, release: 4, cutoff: 60
        # Plays once every time we enter the loop and do often the nr. of iters
        num_iters.times do
          sample :bd_tek, amp: 1.5
          sleep 0.5
        end
      end
      
      
      for i in 0..r
        play arr[i], release: 0.75 # play the current value
        sample :drum_heavy_kick, amp: 1.5 # Play a sound when a swap happens
        sleep 0.25
        if arr[i] > arr[i+1]
          arr[i], arr[i+1] = arr[i+1], arr[i]
          swapped = true if !swapped
          sample :drum_heavy_kick, amp: 2 # Play a sound when a swap happens
          sleep 0.25 # Wait for 0.25s
          play arr[i], amp: 1.5, release: 1.5 # Play the value which the current value was being compared to
          sleep 0.25
          swaps += 1
        end
      end
      
      total_swaps += swaps
      swaps_per_iter.push(swaps)
      
      swapped ? swapped = false : break
      
      array_states.push(arr.dup)
    end
    # Plays the final sorted array once
    arr.each { |n| play n; sleep 0.25 }
    
    time_of_exec = Time.now - start_time
    [arr, total_swaps, swaps_per_iter, num_iters, time_of_exec, array_states]
    
  end
  
  
  with_fx :reverb, room: 0.5 do
    live_loop :sort do
      bubble_sort unsorted_arr
    end
  end